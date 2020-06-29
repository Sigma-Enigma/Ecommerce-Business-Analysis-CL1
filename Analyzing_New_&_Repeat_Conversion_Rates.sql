-- Analyzing New & Repeat Conversion Rates

-- will need order data so join orders, also session data to determine number of potential buyers

SELECT
	website_sessions.is_repeat_session,
    COUNT(website_sessions.website_session_id) AS sessions,
    COUNT(orders.order_id) / COUNT(website_sessions.website_session_id) AS conv_rate,
    SUM(price_usd) / COUNT(website_sessions.website_session_id) AS rev_per_session
    
FROM website_sessions
	LEFT JOIN orders
    ON orders.website_session_id = website_sessions.website_session_id
    
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-08'

GROUP BY
website_sessions.is_repeat_session
;

-- columns is_repeat_session (either row group 0 or row group 1), sessions, conv_rate, rev_per_session
