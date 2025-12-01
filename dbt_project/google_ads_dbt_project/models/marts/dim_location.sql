{{ config(materialized='table') }}

SELECT
    FARM_FINGERPRINT(location) AS location_id,
    location

FROM {{ ref('stg_ads') }}
GROUP BY location