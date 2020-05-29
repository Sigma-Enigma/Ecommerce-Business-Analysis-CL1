-- Analyzing Product Launches

CREATE TEMPORARY TABLE t1

SELECT 
	website_sessions.website_session_id,
    website_sessions.created_at AS created_at_wsi,
    orders.order_id AS order_id,
    orders.created_at AS created_at_order,
    orders.primary_product_id,
    orders.items_purchased,
    orders.price_usd,
    orders.cogs_usd
	
FROM website_sessions
LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id

WHERE website_sessions.created_at BETWEEN '2012-04-01' AND '2013-04-05';


SELECT -- one way to do aggregate
	YEAR(created_at_wsi) AS yr,
    MONTH(created_at_wsi) AS mo,
    COUNT( DISTINCT order_id) AS orders,
    COUNT( DISTINCT website_session_id) AS sessions,
    COUNT( DISTINCT order_id) / COUNT( DISTINCT website_session_id) AS conv_rate,
	SUM(  ( price_usd) * ( items_purchased) ) / COUNT( DISTINCT website_session_id ) AS rev_per_sess,
    SUM( CASE WHEN ( primary_product_id) = 1 THEN 1 ELSE 0 END ) AS prod_one_orders,
	SUM( CASE WHEN ( primary_product_id) = 2 THEN 1 ELSE 0 END ) AS prod_two_orders
    
FROM t1

GROUP BY yr, mo
ORDER BY yr, mo;

SELECT -- second way to do aggregate so long as 
	YEAR(created_at_wsi) AS yr,
    MONTH(created_at_wsi) AS mo,
    COUNT( DISTINCT order_id) AS orders,
    COUNT( DISTINCT website_session_id) AS sessions,
    COUNT( DISTINCT order_id) / COUNT( DISTINCT website_session_id) AS conv_rate,
    SUM( price_usd * items_purchased ) / COUNT( DISTINCT website_session_id )  AS rev_per_sess,
    COUNT( DISTINCT CASE WHEN primary_product_id = 1 THEN order_id ELSE NULL END ) AS prod_one_orders,
	COUNT( DISTINCT CASE WHEN primary_product_id = 2 THEN order_id ELSE NULL END ) AS prod_two_orders
    
FROM t1

GROUP BY yr, mo
ORDER BY yr, mo;

SELECT -- This query stops the odd bug where duplicate grouping rows appear. Why is the distinct function causing this issue? Inspect data to find likely entry errors. Likely way to solve issue is to clean table first use distinct function. This remove duplicates and stores the cleaned data as a temp table as opposed to using DISTINCT within each function.
	YEAR(created_at_wsi) AS yr,
    MONTH(created_at_wsi) AS mo,
    COUNT(  order_id) AS orders,
    COUNT(  website_session_id) AS sessions,
    COUNT(  order_id) / COUNT(  website_session_id) AS conv_rate,
    SUM(  price_usd * items_purchased ) / COUNT( website_session_id )  AS rev_per_sess,
    SUM( CASE WHEN primary_product_id = 1 THEN 1 ELSE 0 END ) AS prod_one_orders,
	SUM( CASE WHEN primary_product_id = 2 THEN 1 ELSE 0 END ) AS prod_two_orders
    
FROM t1

GROUP BY yr, mo
ORDER BY yr, mo;



DROP TABLE t1;