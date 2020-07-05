-- Analysis to Secure Second Funding Round 

-- Objectives
-- tell story of company growth using trended performance data
-- Focus on ad channels and website optimization (how changes made the company more efficient and profitable)

-- Specific Things to Address
-- 1. Volume of growth. Overall session and order volume, trended by quarter. Including current incomplete quarter.
-- 2. Efficiency of improvements. Conversion rates, revenue per order, and revenue per session, trended by quarter.
-- 3. Channel growth. Orders grouped by ad channel, trended quarterly.
-- 4. Channel specific conversion rates. Session to order conv rate, grouped by channel, trended by quarter. Note periods of large improvements.
-- 5. Montly total revenue, total sales, and montly revenue and margin by product.
-- 6. Montly sessions to products page. % of sessions that click to next page in funnel. Conversion rate from /products to placing order.
-- 7. Cross sell analysis for products from '2014-12-05' to current date
-- 8. Share recommendations for improvements the company can still make to further improve efficiency and profitability.

-- Date is '2015-03-20'

USE ecommerce_data;

SELECT
	YEAR(website_sessions.created_at) AS yr,
    QUARTER(website_sessions.created_at) AS qtr,
    COUNT(website_sessions.website_session_id) AS sessions,
    COUNT(CASE WHEN orders.order_id IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END  ) AS orders,
    ROUND( 100*COUNT(CASE WHEN orders.order_id IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END  ) / COUNT(website_sessions.website_session_id), 2) AS '% conv_rate',
    ROUND( 100*SUM( orders.price_usd) / COUNT( orders.order_id), 2) AS rev_per_order,
    ROUND( 100*SUM( orders.price_usd) / COUNT( website_sessions.website_session_id), 2) AS rev_per_session,
    COUNT( CASE WHEN website_sessions.utm_source = 'gsearch' AND website_sessions.utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END ) AS gsearch_nonbrand_orders,
    ROUND( 100*COUNT( CASE WHEN website_sessions.utm_source = 'gsearch' AND website_sessions.utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END ) / COUNT( CASE WHEN website_sessions.utm_source = 'gsearch' AND website_sessions.utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END ), 2) AS '% gsearch_nonbrand_conv',
    COUNT( CASE WHEN website_sessions.utm_source = 'bsearch' AND website_sessions.utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END ) AS bsearch_nonbrand_orders,
    ROUND( 100*COUNT( CASE WHEN website_sessions.utm_source = 'bsearch' AND website_sessions.utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END ) / COUNT( CASE WHEN website_sessions.utm_source = 'bsearch' AND website_sessions.utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END ), 2) AS '% bsearch_nonbrand_conv',
    COUNT( CASE WHEN website_sessions.utm_campaign = 'brand' THEN orders.order_id ELSE NULL END ) AS all_brand_orders,
    ROUND( 100*COUNT( CASE WHEN website_sessions.utm_campaign = 'brand' THEN orders.order_id ELSE NULL END ) / COUNT( CASE WHEN website_sessions.utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END ), 2) AS '% all_brand_conv',
    COUNT( CASE WHEN (website_sessions.utm_source IS NULL) AND (website_sessions.utm_campaign IS NULL) AND (http_referer IS NOT NULL) THEN orders.order_id ELSE NULL END ) AS organic_search_orders,
    ROUND( 100*COUNT( CASE WHEN (website_sessions.utm_source IS NULL) AND (website_sessions.utm_campaign IS NULL) AND (http_referer IS NOT NULL) THEN orders.order_id ELSE NULL END ) / COUNT( CASE WHEN (website_sessions.utm_source IS NULL) AND (website_sessions.utm_campaign IS NULL) AND (http_referer IS NOT NULL) THEN website_sessions.website_session_id ELSE NULL END ), 2) AS '% organic_search_conv',
    COUNT( CASE WHEN (website_sessions.utm_source IS NULL) AND (website_sessions.utm_campaign IS NULL) AND (http_referer IS NULL) THEN orders.order_id ELSE NULL END ) AS direct_type_in_orders,
    ROUND( 100*COUNT( CASE WHEN (website_sessions.utm_source IS NULL) AND (website_sessions.utm_campaign IS NULL) AND (http_referer IS NULL) THEN orders.order_id ELSE NULL END ) / COUNT( CASE WHEN (website_sessions.utm_source IS NULL) AND (website_sessions.utm_campaign IS NULL) AND (http_referer IS NULL) THEN website_sessions.website_session_id ELSE NULL END ), 2) AS '% direct_type_in_conv'

FROM website_sessions
LEFT JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id

WHERE website_sessions.created_at BETWEEN '2012-01-01'  AND '2015-03-20'

GROUP BY 1,2
;


-- next steps add monthly trending data analysis that focuses on product level analysis as well as cross selling analysis

SELECT 
	YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mo, -- cool note: you can round to nearest hundred using negative integer values
    ROUND( SUM(orders.price_usd)/1000, 3) AS 'rev_in_thousands', -- change later to specific product level metric using case for each product
    ROUND( SUM(orders.price_usd  - orders.cogs_usd)/1000, 3) AS 'margin_in_thousands',
    COUNT( orders.order_id) AS total_sales,
	ROUND( SUM( CASE WHEN orders.primary_product_id = 1 THEN orders.price_usd / 1000 ELSE NULL END ), 3) AS rev_prod1,
    ROUND( SUM( CASE WHEN orders.primary_product_id = 1 THEN (orders.price_usd - orders.cogs_usd) / 1000 ELSE NULL END ), 3) AS margin_prod1,
    ROUND( SUM( CASE WHEN orders.primary_product_id = 2 THEN orders.price_usd / 1000 ELSE NULL END ), 3) AS rev_prod2,
    ROUND( SUM( CASE WHEN orders.primary_product_id = 2 THEN (orders.price_usd - orders.cogs_usd) / 1000 ELSE NULL END ), 3) AS margin_prod2,
    ROUND( SUM( CASE WHEN orders.primary_product_id = 3 THEN orders.price_usd / 1000 ELSE NULL END ), 3) AS rev_prod3,
    ROUND( SUM( CASE WHEN orders.primary_product_id = 3 THEN (orders.price_usd - orders.cogs_usd) / 1000 ELSE NULL END ), 3) AS margin_prod3,
    ROUND( SUM( CASE WHEN orders.primary_product_id = 4 THEN orders.price_usd / 1000 ELSE NULL END ), 3) AS rev_prod4,
    ROUND( SUM( CASE WHEN orders.primary_product_id = 4 THEN (orders.price_usd - orders.cogs_usd) / 1000  ELSE NULL END ), 3) AS margin_prod4
        
FROM website_sessions
LEFT JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id

WHERE website_sessions.created_at BETWEEN '2012-01-01' AND '2015-03-20'

GROUP BY 1, 2
;

-- Ideally the above tables would be plotted as a time series to visualize trends and seasonality

SELECT
	*
    
FROM website_pageviews
LEFT JOIN orders
	ON website_pageviews.website_session_id = orders.website_session_id -- This is the 2nd phase; may need a separate join for website_pageview_id for product pages for first phase

WHERE website_pageviews.created_at < '2015-03-20'

; -- cut down to only first product per session_id


-- counts of views to /products pageview_url and conversin rates to next pages in funnel ( first select first /products pageview by finding (pageview_id, where pageview_url = /products), then self join to website_pageviews with same session_id and a pageview_id > itself (if it doesnt it will return NULL), also conversion rates from /products to order_id
-- left join website_pageviews to orders via website_session_id
