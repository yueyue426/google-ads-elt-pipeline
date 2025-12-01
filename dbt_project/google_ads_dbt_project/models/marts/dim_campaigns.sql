{{ config(materialized='table') }}

SELECT
    -- Create the surrogate key by hashing the unique name
    FARM_FINGERPRINT(campaign_name) AS campaign_id,
    campaign_name

FROM {{ ref('stg_ads') }}
GROUP BY campaign_name -- Ensure uniqueness