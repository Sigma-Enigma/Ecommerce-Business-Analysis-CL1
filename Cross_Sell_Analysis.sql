-- Cross Sell Analysis

-- started adding 2nd product on cart page on  '2013-08-25' until '2013-09-25' AND '2013-09-25' until '2013-10-25'
-- month before vs month after
-- ctr from cart (to shipping), average products per order, average order value, (avg) revenue per cart page view

-- plan

-- grab web sessions (and min_webpage_id) that made it to cart between time frames and their corresponding pageview_ids, label each session as A group and B group

-- for each session from above subset, create new column that indicates how many items purchased (join with order_items and use is_primary_item)

-- for each session from agove subset, create new column that indicates value of each item sold 

USE ecommerce_data;


SELECT

website_session_id,
website_pageview_id,
pageview_url,
created_at

FROM website_pageviews

WHERE 
	created_at BETWEEN '2013-08-25' AND '2013-10-25'
	AND pageview_url = '/cart'
;

CREATE TEMPORARY TABLE t2
SELECT 

	CASE 
	WHEN website_pageviews.created_at < '2013-09-25' THEN 'A_group' 
    WHEN website_pageviews.created_at >= '2013-09-25' THEN 'B_group' 
    ELSE NULL END AS test_group,
    website_pageviews.website_session_id,
    website_pageviews.website_pageview_id,
	website_pageviews.pageview_url
    
FROM website_pageviews

WHERE 
	website_pageviews.created_at BETWEEN '2013-08-25' AND '2013-10-25'
	AND website_pageviews.pageview_url = '/thank-you-for-your-order'
;

CREATE TEMPORARY TABLE t3
SELECT 

	CASE 
	WHEN website_pageviews.created_at < '2013-09-25' THEN 'A_group' 
    WHEN website_pageviews.created_at >= '2013-09-25' THEN 'B_group' 
    ELSE NULL END AS test_group,
    website_pageviews.website_session_id,
    website_pageviews.website_pageview_id,
	website_pageviews.pageview_url
    
FROM website_pageviews

WHERE 
	website_pageviews.created_at BETWEEN '2013-08-25' AND '2013-10-25'
	AND website_pageviews.pageview_url = '/shipping'
;

SELECT

	CASE 
	WHEN website_pageviews.created_at < '2013-09-25' THEN 'A_group' 
    WHEN website_pageviews.created_at >= '2013-09-25' THEN 'B_group' 
    ELSE NULL END AS test_group,
    -- website_pageviews.website_session_id,
    COUNT( DISTINCT website_pageviews.website_session_id) AS cart_sessions,
    COUNT( DISTINCT t3.website_session_id) AS shipping_sessions,
    COUNT( DISTINCT t2.website_session_id) AS conversion_sessions,
	COUNT( DISTINCT t2.website_session_id) / COUNT( DISTINCT website_pageviews.website_session_id) AS ctr,
    COUNT( DISTINCT orders.order_id ) AS tot_orders,
	COUNT( DISTINCT order_items.order_item_id) AS tot_order_items,
    COUNT( DISTINCT order_items.order_item_id) / COUNT( DISTINCT orders.order_id ) AS prods_per_order,
	SUM( order_items.price_usd  ) AS tot_sales,
    SUM( order_items.cogs_usd ) AS tot_costs,
    SUM( order_items.price_usd  ) - SUM( order_items.cogs_usd ) AS revenue,
	ROUND( (SUM( order_items.price_usd  ) - SUM( order_items.cogs_usd ) ) / COUNT(DISTINCT orders.order_id), 2) AS avg_rev_per_order,
    ROUND( (SUM( order_items.price_usd  ) - SUM( order_items.cogs_usd ) ) / COUNT( DISTINCT website_pageviews.website_session_id), 2) AS avg_rev_per_sess
    
    
FROM website_pageviews
	LEFT JOIN orders
    ON orders.website_session_id = website_pageviews.website_session_id
    LEFT JOIN order_items
    ON orders.order_id = order_items.order_id
    LEFT JOIN t2
    ON t2.website_session_id = website_pageviews.website_session_id
    LEFT JOIN t3
    ON t3.website_session_id = website_pageviews.website_session_id

WHERE 
	website_pageviews.created_at BETWEEN '2013-08-25' AND '2013-10-25'
	AND website_pageviews.pageview_url = '/cart'

GROUP BY 1
;

DROP TABLE t2;
DROP TABLE t3;