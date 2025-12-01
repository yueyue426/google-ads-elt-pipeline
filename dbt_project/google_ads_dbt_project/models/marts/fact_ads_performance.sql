{{ config(materialized = 'table') }}

WITH base AS (
    SELECT
        ad_id,
        campaign_name,
        clicks,
        impressions,
        leads,
        conversions,
        cost,
        sale_amount,
        ad_date,
        location,
        device
    FROM {{ ref('stg_ads') }}
)

SELECT 
    b.ad_id,
    dc.campaign_id,
    dd.date_id,
    dde.device_id,
    dl.location_id,
    b.clicks,
    b.impressions,
    b.leads,
    b.conversions,
    b.cost,
    b.sale_amount
FROM base b 
LEFT JOIN {{ ref('dim_campaigns') }} dc ON b.campaign_name = dc.campaign_name
LEFT JOIN {{ ref('dim_date') }} dd ON b.ad_date = dd.date_id
LEFT JOIN {{ ref('dim_device') }} dde ON b.device = dde.device
LEFT JOIN {{ ref('dim_location') }} dl ON b.location = dl.location;
    