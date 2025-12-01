{{ config(materialized='table') }}

SELECT
    FARM_FINGERPRINT(device) AS device_id,
    device

FROM {{ ref('stg_ads') }}
GROUP BY device;