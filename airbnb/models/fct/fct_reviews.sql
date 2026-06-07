-- This is how we can create an incremental table: using Jinja tags
{{
  config(
    materialized = 'incremental',
    on_schema_change='fail'
  )
}}

WITH src_reviews AS (
  SELECT * FROM {{ ref('src_reviews') }}
)
SELECT * FROM src_reviews
WHERE review_text is not null

-- This is how we define the incremental strategy!
{% if is_incremental() %}
  AND review_date > (select max(review_date) from {{ this }})
{% endif %}


-- To test if it's incremental, run these test INSERT commands:

-- # 01. Retrieve all rows
-- SELECT * FROM "AIRBNB"."DEV"."FCT_REVIEWS" WHERE listing_id=3176;

-- # 02. Insert value
-- INSERT INTO "AIRBNB"."RAW"."RAW_REVIEWS"
-- VALUES (3176, CURRENT_TIMESTAMP(), 'Zoltan', 'excellent stay!', 'positive');

-- # 03. Updating
-- dbt run

-- # 04. Recheck rows
-- SELECT * FROM "AIRBNB"."DEV"."FCT_REVIEWS" WHERE listing_id=3176;