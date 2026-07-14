-- This is how we can create an incremental table: using Jinja tags
{{
  config(
    materialized = 'incremental',
    on_schema_change='fail',
    event_time='review_date'
  )
}}

WITH src_reviews AS (
  SELECT * FROM {{ ref('src_reviews') }}
)

SELECT
  {{ dbt_utils.generate_surrogate_key(
    ['listing_id', 'review_date', 'reviewer_name', 'review_text']
  ) }} AS review_id,
  *
FROM src_reviews
WHERE review_text is not null

-- Better way to do it: use date var parameters to rerun the pipeline when needed
-- To run:
-- dbt run --select fct_reviews  --vars '{start_date: "2024-02-15 00:00:00", end_date: "2024-03-15 23:59:59"}'

{% if is_incremental() %}

  {% if var("start_date", False) and var("end_date", False) %}
    {{ log('Loading ' ~ this ~ ' incrementally (start_date: ' ~ var("start_date") ~ ', end_date: ' ~ var("end_date") ~ ')', info=True) }}
    AND review_date >= '{{ var("start_date") }}'
    AND review_date < '{{ var("end_date") }}'

  {% else %}
    AND review_date > (select max(review_date) from {{ this }})
    {{ log('Loading ' ~ this ~ ' incrementally (all missing dates)', info=True)}}
  {% endif %}

{% endif %}

-- Old naive way to do it!
-- -- This is how we define the incremental strategy!
-- {% if is_incremental() %}
--   AND review_date > (select max(review_date) from {{ this }})
-- {% endif %}


-- -- To test if it's incremental, run these test INSERT commands:

-- -- # 01. Retrieve all rows
-- -- SELECT * FROM "AIRBNB"."DEV"."FCT_REVIEWS" WHERE listing_id=3176;

-- -- # 02. Insert value
-- -- INSERT INTO "AIRBNB"."RAW"."RAW_REVIEWS"
-- -- VALUES (3176, CURRENT_TIMESTAMP(), 'Zoltan', 'excellent stay!', 'positive');

-- -- # 03. Updating
-- -- dbt run

-- -- # 04. Recheck rows
-- -- SELECT * FROM "AIRBNB"."DEV"."FCT_REVIEWS" WHERE listing_id=3176;