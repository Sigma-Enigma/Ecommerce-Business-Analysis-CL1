-- Product Level Website Path Analysis

-- select subset of website sessions that clicked to products (denominator of sessions)
-- for each session, find the minimum wepsite_pageview_id (or min created_at) where pageview_url = /products, print this value in column
-- also for each session, find the 2nd 


-- for each session that went to products, take the subset that went to another page
-- list urls that they visted directly after

-- Finish later

SELECT
	COUNT( DISTINCT website_pageviews ) AS sessions,
	COUNT( CASE WHEN THEN ELSE END) AS w_nextpage,
	AS pct_nextpage,
	COUNT( CASE WHEN THEN ELSE END ) AS mrfuzzy,
	AS pct_mrfuzzy,
	COUNT( CASE WHEN THEN ELSE END ) AS lovebear,
	AS pct_lovebear

FROM website_pageviews

WHERE created_at BETWEEN '2013-01-05' AND '2013-04-06'


ORDER BY
;



SELECT

FROM website_pageviews

WHERE created_at BETWEEN '2012-10-05' AND '2013-01-06' 

GROUP BY

ORDER BY
;