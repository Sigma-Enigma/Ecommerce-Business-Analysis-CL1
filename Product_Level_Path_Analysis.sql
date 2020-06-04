-- Product Level Website Path Analysis

USE ecommerce_data;

CREATE TEMPORARY TABLE product_pageviews
SELECT

	website_session_id,
    website_pageview_id,
    created_at,
    CASE 
		WHEN created_at < '2013-01-06' THEN 'A_pre_product'
        WHEN created_at >= '2013-01-06' THEN 'B_post_product'
        ELSE 'logic error'
        
	END AS time_period 
FROM website_pageviews 

WHERE
	created_at > '2012-10-06'
    AND created_at < '2013-04-06'
    AND pageview_url = '/products'
;
    

-- next session ID's

CREATE TEMPORARY TABLE next_session_id
SELECT 
	product_pageviews.time_period,
    product_pageviews.website_session_id,
    MIN( website_pageviews.website_pageview_id) AS min_next_pageview_id

FROM product_pageviews

LEFT JOIN website_pageviews
	ON website_pageviews.website_session_id = product_pageviews.website_session_id
    AND website_pageviews.website_pageview_id > product_pageviews.website_pageview_id

GROUP BY 1,2
;


-- CREATE TEMPORARY TABLE merged_table1
SELECT
	next_session_id.time_period,
    next_session_id.website_session_id,
    next_session_id.min_next_pageview_id,
    website_pageviews.pageview_url

FROM next_session_id

LEFT JOIN website_pageviews
	ON website_pageviews.website_pageview_id = next_session_id.min_next_pageview_id
;


SELECT

	merged_table1.time_period,
    COUNT( DISTINCT merged_table1.website_session_id) AS sessions,
    COUNT( DISTINCT merged_table1.min_next_pageview_id ) AS sessions_w_next_page,
	COUNT( DISTINCT merged_table1.min_next_pageview_id ) / COUNT( DISTINCT merged_table1.website_session_id) AS pct_next_page,
    COUNT( CASE WHEN merged_table1.pageview_url = '/the-original-mr-fuzzy' THEN merged_table1.pageview_url ELSE NULL END ) AS mr_fuzzy,
	COUNT( CASE WHEN merged_table1.pageview_url = '/the-original-mr-fuzzy' THEN merged_table1.pageview_url ELSE NULL END) /  COUNT( DISTINCT merged_table1.website_session_id) AS pct_mr_fuzzy,
    COUNT( CASE WHEN merged_table1.pageview_url = '/the-forever-love-bear' THEN merged_table1.pageview_url ELSE NULL END) AS love_bear,
    COUNT( CASE WHEN merged_table1.pageview_url = '/the-forever-love-bear' THEN merged_table1.pageview_url ELSE NULL END) /  COUNT( DISTINCT merged_table1.website_session_id) AS pct_love_bear
    
FROM merged_table1

GROUP BY merged_table1.time_period;


DROP TABLE product_pageviews;
DROP TABLE next_session_id;  
DROP TABLE merged_table1;
