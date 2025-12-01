{{ config(materialized = 'table') }}

WITH base AS (
    SELECT
        date_id,
        campaign_id,
        location_id,
        device_id,
        clicks,
        impressions,
        conversions,
        cost,
        sale_amount
    FROM {{ ref('fact_ads_performance') }}
)
SELECT
    date_id,
    campaign_id,
    location_id,
    device_id,
    clicks,
    impressions,
    conversions,
    cost,
    sale_amount,
    -- KPI metrics
    SAFE_DIVIDE(clicks, impressions) AS CTR, -- clicks per impression
    SAFE_DIVIDE(cost, clicks) AS CPC, -- cost per clicks
    SAFE_DIVIDE(cost, conversions) AS CPA, -- cost per conversion
    SAFE_DIVIDE(conversions, clicks) AS coverstion_rate,
    SAFE_DIVIDE(sale_amount - cost, cost) AS ROI,
    sale_amount - cost AS profit
FROM base
