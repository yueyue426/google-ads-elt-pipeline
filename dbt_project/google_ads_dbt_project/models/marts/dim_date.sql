{{ config(materialized = 'table') }}

SELECT DISTINCT
    ad_date AS date_id,
    EXTRACT(YEAR FROM ad_date) AS year,
    EXTRACT(MONTH FROM ad_date) AS month,
    FORMAT_DATE('%B', ad_date) AS month_name,
    EXTRACT(DAY FROM ad_date) AS day
FROM {{ ref('stg_ads') }}