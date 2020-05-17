-- Landing Page Trend Analysis

USE ecommerce_data;

-- Find time period to do analysis (when A/B test starts)


SELECT 
	website_pageview_id,
    created_at
FROM website_pageviews
WHERE (created_at BETWEEN '2012-06-01' AND '2012-08-31') AND pageview_url = '/lander-1'
ORDER BY created_at ASC -- lower bound of created_at = '2012-06-18 22:35:53'
LIMIT 100;

-- Now Do bounce rate analysis but this restricting analysis to sessions from gsearch sources and nonbranded campaigns (do this by joining with website_sessions table)

CREATE TEMPORARY TABLE sessions_bounced2 -- by session id

SELECT
	website_pageviews.website_session_id AS bounced_website_session_id,
    website_sessions.utm_source,
    website_sessions.utm_campaign,
    COUNT( DISTINCT website_pageviews.website_pageview_id ) AS pages_viewed_by_session
FROM website_pageviews
LEFT JOIN website_sessions
	ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE (website_pageviews.created_at BETWEEN '2012-06-01' AND '2012-08-31') AND (utm_source = 'gsearch') AND (utm_campaign = 'nonbrand')
GROUP BY website_pageviews.website_session_id, website_sessions.utm_source, website_sessions.utm_campaign
HAVING pages_viewed_by_session < 2;



CREATE TEMPORARY TABLE min_pv_id_by_session_id2

SELECT 
	website_sessions.website_session_id,
    website_sessions.utm_source, 
    website_sessions.utm_campaign,
    MIN( website_pageview_id) AS min_pv_id
FROM website_pageviews
LEFT JOIN website_sessions
	ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE (website_pageviews.created_at BETWEEN '2012-06-01' AND '2012-08-31') AND (utm_source = 'gsearch') AND (utm_campaign = 'nonbrand')
GROUP BY website_pageviews.website_session_id, website_sessions.utm_source, website_sessions.utm_campaign;


CREATE TEMPORARY TABLE landing_page_by_session_id2

SELECT
	min_pv_id_by_session_id2.website_session_id AS website_session_id,
    website_pageviews.pageview_url AS landing_page_url
FROM min_pv_id_by_session_id2
LEFT JOIN website_pageviews
	ON min_pv_id_by_session_id2.website_session_id = website_pageviews.website_session_id;


SELECT
	YEARWEEK(website_pageviews.created_at) AS week_no,
    MIN(website_pageviews.created_at) AS week_start,
	COUNT( DISTINCT sessions_bounced2.bounced_website_session_id) / COUNT(  DISTINCT landing_page_by_session_id2.website_session_id) AS bounce_rate,
    COUNT(  DISTINCT CASE WHEN landing_page_by_session_id2.landing_page_url = '/home' THEN landing_page_by_session_id2.website_session_id END) AS home_sessions,
    COUNT(  DISTINCT CASE WHEN landing_page_by_session_id2.landing_page_url = '/lander-1' THEN landing_page_by_session_id2.website_session_id END) AS lander1_sessions
FROM landing_page_by_session_id2
LEFT JOIN sessions_bounced2
	ON landing_page_by_session_id2.website_session_id = sessions_bounced2.bounced_website_session_id
LEFT JOIN website_pageviews
	ON landing_page_by_session_id2.website_session_id = website_pageviews.website_session_id
GROUP BY week_no
HAVING bounce_rate > 0
ORDER BY week_start ASC;

/*
DROP TABLE sessions_bounced2;
DROP TABLE min_pv_id_by_session_id2;
DROP TABLE landing_page_by_session_id2;
*/