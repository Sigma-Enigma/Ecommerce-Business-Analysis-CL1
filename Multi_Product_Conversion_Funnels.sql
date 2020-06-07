-- full conversion funnel for each product from 2013-01-06 (product page to sale, with counts and percentages ctr per stage in funnel)

-- only want websessions that viewed either mrfuzzy or lovebear product pages

USE ecommerce_data;

SELECT 
    pageview_url,
    MIN( created_at) AS min_time,
    MAX( created_at) AS max_time
    
FROM website_pageviews


WHERE 
	created_at BETWEEN '2013-01-06' AND '2013-04-10'
    AND 
	(pageview_url = '/the-original-mr-fuzzy' OR pageview_url = '/the-forever-love-bear' )
GROUP BY 1
;

SELECT 
    pageview_url,
    COUNT(website_session_id) AS sessions,
    COUNT( DISTINCT website_session_id) as distinct_sessions,
    COUNT(pageview_url) AS pvs,
    COUNT( DISTINCT pageview_url) as distinct_pvs
    
FROM website_pageviews

WHERE 
	created_at BETWEEN '2013-01-06' AND '2013-04-10'
    AND 
	(pageview_url = '/the-original-mr-fuzzy' OR pageview_url = '/the-forever-love-bear' )
GROUP BY 1
;


-- for each session find min pageview ID for either mrfuzzy OR lovebear

CREATE TEMPORARY TABLE saw_products

SELECT 
    website_session_id,
    website_pageview_id,
	pageview_url AS product_seen

FROM website_pageviews

WHERE 
	created_at BETWEEN '2013-01-06' AND '2013-04-10'
    AND 
	(pageview_url = '/the-original-mr-fuzzy' OR pageview_url = '/the-forever-love-bear' ) -- may want to include cause to minimum pageview_id for each product return a number or NULL for cross-sell analysis (covariance analysis)
;


SELECT
saw_products.product_seen,
COUNT(  CASE WHEN saw_products.product_seen = website_pageviews.pageview_url THEN website_pageviews.website_session_id ELSE NULL END) AS sessions, -- note you need to use distinct here because the left table begins with duplicate 
COUNT(  CASE WHEN website_pageviews.pageview_url = '/cart' THEN website_pageviews.website_session_id ELSE NULL END ) AS to_cart,
COUNT(  CASE WHEN website_pageviews.pageview_url = '/cart' THEN website_pageviews.website_session_id ELSE NULL END ) / COUNT(  CASE WHEN saw_products.product_seen = website_pageviews.pageview_url THEN website_pageviews.website_session_id ELSE NULL END)   AS pct_to_cart,
COUNT(  CASE WHEN website_pageviews.pageview_url = '/shipping' THEN website_pageviews.website_session_id ELSE NULL END ) AS to_shipping,
COUNT(  CASE WHEN website_pageviews.pageview_url = '/shipping' THEN website_pageviews.website_session_id ELSE NULL END )  / COUNT(  CASE WHEN website_pageviews.pageview_url = '/cart' THEN website_pageviews.website_session_id ELSE NULL END ) AS pct_to_shipping,
COUNT(  CASE WHEN website_pageviews.pageview_url = '/billing-2' THEN website_pageviews.website_session_id ELSE NULL END ) AS to_billing2,
COUNT(  CASE WHEN website_pageviews.pageview_url = '/billing-2' THEN website_pageviews.website_session_id ELSE NULL END ) / COUNT(  CASE WHEN website_pageviews.pageview_url = '/shipping' THEN website_pageviews.website_session_id ELSE NULL END ) AS pct_to_billing2,
COUNT(  CASE WHEN website_pageviews.pageview_url = '/thank-you-for-your-order' THEN website_pageviews.website_session_id ELSE NULL END ) AS to_thankyou,
COUNT(  CASE WHEN website_pageviews.pageview_url = '/thank-you-for-your-order' THEN website_pageviews.website_session_id ELSE NULL END )  / COUNT( CASE WHEN website_pageviews.pageview_url = '/billing-2' THEN website_pageviews.website_session_id ELSE NULL END ) AS pct_to_thankyou

FROM website_pageviews
	LEFT JOIN saw_products
		ON saw_products.website_session_id = website_pageviews.website_session_id -- note for future analyses: you may want to specify only website_pageviews that occur AFTER the initial (or ultimate) view of the product page PER web_session to do this use an AND operator in the ON clause where webpage ID's> 

WHERE 
    saw_products.product_seen IS NOT NULL

GROUP BY saw_products.product_seen
;

DROP TABLE saw_products;


