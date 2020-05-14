-- Web Landing Page Analysis

USE ecommerce_data;

CREATE TEMPORARY TABLE first_page_by_session

SELECT
	website_session_id,
    MIN( website_pageview_id ) AS first_page

FROM website_pageviews

WHERE created_at < '2012-06-12'

GROUP BY website_session_id;



SELECT
	website_pageviews.pageview_url AS land_page,
	COUNT( DISTINCT first_page_by_session.website_session_id) AS tot_sessions_per_page
    
FROM first_page_by_session

LEFT JOIN website_pageviews
	ON first_page_by_session.first_page = website_pageviews.website_pageview_id
    
GROUP BY website_pageviews.pageview_url;
