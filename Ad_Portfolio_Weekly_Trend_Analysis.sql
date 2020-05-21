-- Channel Ad Portfolio Weekly Trend Analysis by Volume

USE ecommerce_data;

SELECT
    YEARWEEK(created_at) AS year_week_no,
    MIN(DATE(created_at)) AS week_start_date,
    COUNT( DISTINCT website_session_id) AS total_sessions,
    COUNT( DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END ) AS gsearch_sessions,
    COUNT( DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END ) AS bsearch_sessions
    
FROM website_sessions

WHERE 
	(created_at BETWEEN '2012-08-022' AND '2012-11-29') 
    AND (utm_campaign = 'nonbrand')

GROUP BY year_week_no;