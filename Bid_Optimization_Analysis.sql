-- Bid Optimization Analysis by Device Type, Ad Source and Ad Campaign

USE ecommerce_data;

SELECT
	website_sessions.device_type, 
    website_sessions.utm_source, 
    website_sessions.utm_campaign,
    COUNT(DISTINCT website_sessions.website_session_id) AS tot_sessions,
    COUNT(DISTINCT orders.order_id) AS tot_orders,
	COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id)  AS conv_rate

FROM website_sessions

LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id
    
WHERE (website_sessions.created_at BETWEEN '2012-03-01' AND '2012-05-11')

GROUP BY
	website_sessions.device_type, website_sessions.utm_source, website_sessions.utm_campaign
    
ORDER BY conv_rate DESC;