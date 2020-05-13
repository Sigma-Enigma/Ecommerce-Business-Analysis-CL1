-- Traffic Source Trend Analysis by Week

SELECT
    WEEK(created_at) AS week_no,
    MIN(DATE(created_at)) AS week_start_date,
    COUNT( DISTINCT website_session_id) AS total_sessions

FROM website_sessions

WHERE (created_at BETWEEN '2012-03-01' AND '2012-05-10') AND (utm_source = 'gsearch') AND (utm_campaign = 'nonbrand')

GROUP BY week_no;


