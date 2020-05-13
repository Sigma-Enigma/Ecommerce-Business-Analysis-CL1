-- Trend Analysis with Granular Segments (Web Traffic Volume by Device Type)

USE ecommerce_data;

SELECT
    WEEK(created_at) AS week_no,
	MIN(DATE(created_at)) AS week_start,
    COUNT( DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id END ) AS tot_desktop_sessions,
    COUNT( DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id END ) AS tot_mobile_sessions
    
FROM website_sessions

WHERE (created_at BETWEEN '2012-04-15' AND '2012-06-09') AND (utm_source = 'gsearch') AND (utm_campaign = 'nonbrand')

GROUP BY week_no

ORDER BY  week_no;