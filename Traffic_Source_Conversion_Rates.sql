-- Traffic Source Conversion Rates by Ad Source and Ad Campaign

SELECT
website_sessions.utm_source,
website_sessions.utm_campaign,
 COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
 COUNT(DISTINCT orders.order_id) AS orders,
 COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS sessions_to_order_conv_ratio
 
 FROM website_sessions
 
 LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id
 
 WHERE (website_sessions.created_at BETWEEN '2012-03-11' AND '2012-04-14')
 
 GROUP BY website_sessions.utm_source, website_sessions.utm_campaign
 
 ORDER BY 5 DESC;