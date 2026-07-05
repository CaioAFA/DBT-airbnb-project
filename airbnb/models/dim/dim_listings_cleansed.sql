{{
  config(
    materialized = 'view',
    event_time='created_at'
  )
}}

WITH src_listings AS (
  SELECT
    *
  FROM
    -- Referencing ./models/src/src_listings.sql using Jinja template engine
    -- Install "Power Used for DBT" VSCode extension to help you on the development,
    -- then select "Jinja SQL" syntax
    {{ ref('src_listings') }}
)

SELECT
  listing_id,
  listing_name,
  room_type,
  CASE
    WHEN minimum_nights = 0 THEN 1
    ELSE minimum_nights
  END AS minimum_nights,
  host_id,
  REPLACE(
    price_str,
    '$'
  ) :: NUMBER(
    10,
    2
  ) AS price,
  created_at,
  updated_at
FROM
  src_listings