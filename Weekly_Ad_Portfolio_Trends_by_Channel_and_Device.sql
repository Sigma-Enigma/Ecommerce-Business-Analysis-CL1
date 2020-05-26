-- Weekly Ad Portfolio Trends by Channel and Device

USE ecommerce_data;

SELECT

	MIN( DATE(website_sessions.created_at) ) AS week_start,
	SUM( CASE WHEN (website_sessions.utm_source = 'gsearch' AND website_sessions.device_type = 'desktop') THEN 1 ELSE 0 END ) AS g_desktop_sessions,
	SUM( CASE WHEN (website_sessions.utm_source = 'bsearch' AND website_sessions.device_type = 'desktop') THEN 1 ELSE 0 END ) AS b_desktop_sessions,
	SUM( CASE WHEN (website_sessions.utm_source = 'bsearch' AND website_sessions.device_type = 'desktop') THEN 1 ELSE 0 END ) / SUM( CASE WHEN (website_sessions.utm_source = 'gsearch' AND website_sessions.device_type = 'desktop') THEN 1 ELSE 0 END ) AS b_pct_of_g_desktop_sessions,
	SUM( CASE WHEN (website_sessions.utm_source = 'gsearch' AND website_sessions.device_type = 'mobile') THEN 1 ELSE 0 END ) AS g_mobile_sessions,
	SUM( CASE WHEN (website_sessions.utm_source = 'bsearch' AND website_sessions.device_type = 'mobile') THEN 1 ELSE 0 END ) AS b_mobile_sessions,
	SUM( CASE WHEN (website_sessions.utm_source = 'bsearch' AND website_sessions.device_type = 'mobile') THEN 1 ELSE 0 END ) / SUM( CASE WHEN website_sessions.utm_source = 'gsearch' AND website_sessions.device_type = 'mobile' THEN 1 ELSE 0 END ) AS b_pct_of_g_mobile_sessions

FROM website_sessions

WHERE 
	(website_sessions.created_at BETWEEN '2012-11-04' AND '2012-12-22') AND
    (website_sessions.utm_campaign = 'nonbrand')

GROUP BY YEARWEEK( website_sessions.created_at );