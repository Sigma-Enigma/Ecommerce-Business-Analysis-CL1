-- Product Portfolio Expansion


-- wants conv rate, average order value, products per order, and revenue per session; all this is comparing across month before and after
-- note: third product launched '2013-12-12'

USE ecommerce_data;

-- select session rows that were in the time period and assign the label group_A or group_B in new column
CREATE TEMPORARY TABLE t1 -- subset of web_sessions to be included in analysis (denominator)
SELECT
	ws.website_session_id,
    ws.created_at,
    CASE
		WHEN created_at < '2013-12-12' THEN 'group_A'
        WHEN created_at >= '2013-12-12' THEN 'group_B'
        ELSE NULL END AS test_group

FROM website_sessions AS ws


WHERE 
	created_at BETWEEN '2013-11-12' AND '2014-01-12'
;

-- checking to see that the joined table is what we expect before performing aggregation. it is, one row for item_rev value
-- notes to self: inspect each table to understand what each table has and how it is formatted, join them and select each value to be used in aggregate query 
-- tip to self: figure out the smallest row unit you want to aggregate by to prevent double counting duplicates when aggregating. In this case, item_rev values
SELECT 
	t1.test_group,
    t1.website_session_id AS sess_id,
	orders.order_id,
    orders.price_usd AS order_rev,
    orders.items_purchased,
    order_items.order_item_id,
    order_items.price_usd AS item_rev
    
FROM website_sessions
	LEFT JOIN t1
    ON t1.website_session_id = website_sessions.website_session_id
	LEFT JOIN orders
    ON orders.website_session_id = website_sessions.website_session_id
    LEFT JOIN order_items
    ON order_items.order_id = orders.order_id
    
WHERE 
	website_sessions.created_at BETWEEN '2013-11-12' AND '2014-01-12'
;

SELECT 
	t1.test_group,
	-- t1.website_session_id,
    COUNT( DISTINCT website_sessions.website_session_id) AS web_sessions,
    COUNT( DISTINCT orders.order_id) / COUNT( DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM( order_items.price_usd) AS tot_rev,
    COUNT( DISTINCT orders.order_id) AS tot_orders,
    SUM( order_items.price_usd) / COUNT( DISTINCT orders.order_id) AS avg_order_value,
    COUNT( DISTINCT order_items.order_item_id) / COUNT( DISTINCT orders.order_id) AS prods_per_order,
    SUM( order_items.price_usd) / COUNT( DISTINCT website_sessions.website_session_id) AS revenue_per_sess

FROM website_sessions
	LEFT JOIN orders
    ON orders.website_session_id = website_sessions.website_session_id
    LEFT JOIN order_items
    ON order_items.order_id = orders.order_id
    LEFT JOIN t1
    ON t1.website_session_id = website_sessions.website_session_id

WHERE 
	website_sessions.created_at BETWEEN '2013-11-12' AND '2014-01-12'
    
GROUP BY 1 -- ,2
;

DROP TABLE t1;

