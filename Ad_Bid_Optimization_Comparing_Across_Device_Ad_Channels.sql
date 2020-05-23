

-- Ad Bid Optimization : Comparing Across Ad Channels by Device Platform

USE ecommerce_data;

SELECT
	website_sessions.device_type,
	website_sessions.utm_source,
    COUNT(DISTINCT website_sessions.website_session_id ) AS total_sessions,
    COUNT(DISTINCT orders.website_session_id ) AS orders,
    COUNT(DISTINCT orders.website_session_id ) / COUNT(DISTINCT website_sessions.website_session_id ) AS conv_rate
    
FROM website_sessions
LEFT JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id

WHERE 
	(website_sessions.utm_campaign = 'nonbrand') AND
    (website_sessions.created_at BETWEEN '2012-08-22' AND '2012-09-19')

GROUP BY website_sessions.device_type, website_sessions.utm_source ;