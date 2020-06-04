-- Product Level Website Path Analysis

-- select subset of website sessions that clicked to products (denominator of sessions)
-- for each session, find the minimum website_pageview_id (or min created_at) where pageview_url = /products, print this value in column
-- also for each session, find the 2nd 


-- for each session that went to products, take the subset that went to another page
-- list urls that they visted directly after

-- Finish later


-- select only sessions that made it to product page (do this for both time windows)
-- then find subset that made it to at least one other page after visting products page AND return the url of the next page this session_id visited (via 2nd min website pageview ID linked via website_session_id)

-- then find subset that made it     "             "                 "              "   AND next url page returned == mr_fuzzy
-- then find subset that made it     "             "                 "              "   AND next url page returned == love_bear


-- eligible sessions
SELECT
	website_session_id,
	MIN( CASE WHEN pageview_url = '/product' THEN website_pageview_id ELSE NULL END ) AS min_product_pageview_id,
    
   
    
    -- return url of min pageview_id
    -- return 2nd min pageview_id
    -- return url of 2nd min pageview_id
    
    
FROM website_pageviews

WHERE created_at BETWEEN '2013-01-05' AND '2013-04-06'

GROUP BY website_session_id

;


 -- MIN( CASE WHEN website_pageview_id > ( MIN( CASE WHEN pageview_url = '/product' THEN website_pageview_id ELSE NULL END) ) THEN website_pageview_id ELSE NULL END) AS second_min_product_pageview_id, 


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