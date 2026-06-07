-- This is a simple model using DBT
-- OBS: if we keep just the SQL, it'll create this model as as view!

-- Go to Snowflake console and check this created view!

-- Common practice between DBT users: select the raw data as CTEs
WITH raw_listings AS (
    SELECT
        *
    FROM
        {{ source('airbnb', 'listings') }}
)

-- Changing some names to enhance readability
SELECT
    id AS listing_id,
    name AS listing_name,
    listing_url,
    room_type,
    minimum_nights,
    host_id,
    price AS price_str,
    created_at,
    updated_at
FROM
    raw_listings