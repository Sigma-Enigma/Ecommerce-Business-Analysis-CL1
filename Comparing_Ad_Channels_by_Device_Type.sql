-- Comparing Ad Channel by Device Platform

USE ecommerce_data;

SELECT
	website_sessions.utm_source,
    COUNT(DISTINCT website_sessions.website_session_id ) AS total_sessions,
    SUM( CASE  WHEN website_sessions.device_type = 'mobile' THEN 1 ELSE 0 END) AS mobile_sessions,
    SUM( CASE  WHEN website_sessions.device_type = 'mobile' THEN 1 ELSE 0 END) / COUNT(DISTINCT website_sessions.website_session_id ) AS prcnt_mobile
    
FROM website_sessions

WHERE 
	(website_sessions.utm_campaign = 'nonbrand') AND
    (website_sessions.created_at BETWEEN '2012-08-22' AND '2012-11-30')

GROUP BY website_sessions.utm_source;