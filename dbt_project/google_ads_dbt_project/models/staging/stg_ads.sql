SELECT
    Ad_ID as ad_id,

    -- Clean column Campaign_Name
    CASE
        WHEN Campaign_Name IN (
            'DataAnalyticsCourse',
            'Data Anlytics Corse',
            'Data Analytcis Course',
            'Data Analytics Corse'
        ) THEN 'Data Analytics Course'
        ELSE Campaign_Name
    END AS campaign_name,

    -- Clean numeric columns
    COALESCE(Clicks, 0) AS clicks,
    COALESCE(Impressions, 0) AS impressions,
    COALESCE(Leads, 0) AS leads,
    COALESCE(Conversions, 0) AS conversions,
    COALESCE(`Conversion Rate`, 0) AS coversion_rate,

    -- Currency cleaning
    CAST(REPLACE(Cost, '$', '') AS NUMERIC) AS cost,
    CAST(REPLACE(Sale_Amount, '$', '') AS NUMERIC) AS sale_amount,

    -- Date cleaning
    PARSE_DATE('%Y-%m-%d', Ad_Date) AS ad_date,

    -- Clean column Location
    CASE
        WHEN LOWER(Location) IN (
            'hyderabad',
            'hyderbad',
            'hydrebad'
        ) THEN 'Hyderabad'
        ELSE INITCAP(Location) -- convert first letter to uppercase and others to lowercase
    END AS location,

    -- Clean column Device
    CASE
        WHEN LOWER(Device) = 'desktop' THEN 'Desktop'
        WHEN LOWER(Device) = 'mobile' THEN 'Mobile'
        WHEN LOWER(Device) = 'tablet' THEN 'Tablet'
        ELSE Device
    END AS device,

    -- Clean column Keyword
    CASE
        WHEN LOWER(Keyword) LIKE '%learn%' THEN 'learn data analytics'
        WHEN LOWER(Keyword) LIKE '%course%' THEN 'data analytics course'
        WHEN LOWER(Keyword) LIKE '%online%' THEN 'data analytics online'
        WHEN LOWER(Keyword) LIKE '%training%' THEN 'data analytics training'
        WHEN LOWER(Keyword) LIKE '%for%' THEN 'analytics for data'
        ELSE LOWER(Keyword)
    END AS keyword

FROM {{ source('raw_staging', 'ads-raw') }};


