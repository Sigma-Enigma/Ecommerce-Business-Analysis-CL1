-- Analyzing Direct Traffic Sources

USE ecommerce_data;


SELECT

YEAR(created_at) AS yr,
MONTH(created_at) AS mo, 
COUNT( CASE WHEN utm_campaign = 'nonbrand' THEN 1 ELSE NULL END ) AS non_brand_sessions,
COUNT( CASE WHEN utm_campaign = 'brand' THEN 1 ELSE NULL END ) AS brand_sessions,
COUNT( CASE WHEN utm_campaign = 'brand' THEN 1 ELSE NULL END ) / COUNT( CASE WHEN utm_campaign = 'nonbrand' THEN 1 ELSE NULL END ) AS brand_pct_of_nonbrand,
COUNT( CASE WHEN http_referer IS NULL THEN 1 ELSE NULL END ) AS direct,
COUNT( CASE WHEN http_referer IS NULL THEN 1 ELSE NULL END ) / COUNT( CASE WHEN utm_campaign = 'nonbrand' THEN 1 ELSE NULL END ) AS direct_pct_of_nonbrand,
COUNT( CASE WHEN ( ( (http_referer = 'https://www.gsearch.com') OR (http_referer = 'https://www.bsearch.com') ) AND utm_campaign IS NULL ) THEN 1 ELSE NULL END ) AS organic,
COUNT( CASE WHEN ( ( (http_referer = 'https://www.gsearch.com') OR (http_referer = 'https://www.bsearch.com') ) AND utm_campaign IS NULL ) THEN 1 ELSE NULL END ) / COUNT( CASE WHEN utm_campaign = 'nonbrand' THEN 1 ELSE NULL END ) AS organic_pct_of_nonbrand

FROM website_sessions

WHERE created_at < '2012-12-23'

GROUP BY yr, mo;


