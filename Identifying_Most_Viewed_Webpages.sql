-- Identifying Most Viewed Webpages

USE ecommerce_data;

SELECT
	pageview_url,
	COUNT( DISTINCT website_session_id ) AS total_unique_views

FROM website_pageviews

WHERE created_at < '2012-06-09'

GROUP BY pageview_url

ORDER BY total_unique_views DESC;