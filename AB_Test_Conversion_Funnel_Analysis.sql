-- AB Test Conversion Funnel Analysis

-- Fix query later

USE ecommerce_data;

SELECT 
	website_pageview_id,
    pageview_url,
    created_at
FROM website_pageviews
WHERE pageview_url = '/billing-2'
ORDER BY created_at ASC
LIMIT 500; -- earliest date '2012-09-09 22:13:04'


 -- use orders table not website pageviews to determine if purchased
SELECT
    SUM( q2.viewed_lander) AS to_lander,
	SUM( q2.viewed_lander) / COUNT( q2.website_session_id) AS ctr_to_lander,
    SUM( q2.viewed_billing) AS to_billing,
    SUM( q2.viewed_billing) / SUM( q2.viewed_lander) AS ctr_to_billing,
    SUM( q2.viewed_order) AS to_order,
    SUM( q2.viewed_order) / SUM( q2.viewed_billing) AS ctr_to_order
FROM
	(SELECT
		q1.website_session_id,
		MAX(q1.is_lander) AS viewed_lander,
		MAX(q1.is_billing) AS viewed_billing,
        MAX(q1.is_billing2) AS viewed_billing2,
        MAX(q1.is_order) AS viewed_order
	FROM
		(SELECT -- building categorical variables to identify each web_pageview_id's url
			website_sessions.website_session_id,
			website_sessions.created_at,
			website_sessions.utm_source,
            orders.order_id,
			CASE WHEN website_pageviews.pageview_url = '/lander-1' THEN 1 ELSE 0 END AS is_lander,
            CASE WHEN orders.order_id IS NOT NULL THEN 1 ELSE 0 END AS is_order,
			CASE WHEN website_pageviews.pageview_url = '/billing' THEN 1 ELSE 0 END AS is_billing,
            CASE WHEN website_pageviews.pageview_url = '/billing-2' THEN 1 ELSE 0 END AS is_billing2
		FROM website_pageviews
		LEFT JOIN website_sessions
			ON website_pageviews.website_session_id = website_sessions.website_session_id
		LEFT JOIN orders
			ON website_pageviews.website_session_id = orders.website_session_id 
		WHERE 
			(website_sessions.created_at BETWEEN '2012-09-09 22:13:04' AND '2012-11-10')
		) AS q1
	GROUP BY q1.website_session_id
	) AS q2 
    WHERE 
    (q2.viewed_billing = 1 ); -- may need to do it is NOT = /billing-2
    
    SELECT
    SUM( q2.viewed_lander) AS to_lander,
	SUM( q2.viewed_lander) / COUNT( q2.website_session_id) AS ctr_to_lander,
    SUM( q2.viewed_products) AS to_products,
    SUM( q2.viewed_products) / SUM( q2.viewed_lander) AS ctr_to_products,
    SUM( q2.viewed_mr_fuzzy) AS to_mr_fuzzy,
	SUM( q2.viewed_mr_fuzzy) / SUM( q2.viewed_products) AS ctr_to_mr_fuzzy,
    SUM( q2.viewed_cart) AS to_cart,
    SUM( q2.viewed_cart) / SUM( q2.viewed_mr_fuzzy) AS ctr_to_cart,
    SUM( q2.viewed_shipping) AS to_shipping,
    SUM( q2.viewed_shipping) / SUM( q2.viewed_cart) AS ctr_to_shipping,
    SUM( q2.viewed_billing2) AS to_billing2,
    SUM( q2.viewed_billing2) / SUM( q2.viewed_shipping) AS ctr_to_billing2,
    SUM( q2.viewed_thank_you) AS to_thank_you,
    SUM( q2.viewed_thank_you ) / SUM( q2.viewed_billing2) AS ctr_to_thank_you
    
FROM
	(SELECT
		q1.website_session_id,
		MAX(q1.is_lander) AS viewed_lander,
		MAX(q1.is_products) AS viewed_products,
		MAX(q1.is_mr_fuzzy) AS viewed_mr_fuzzy,
        MAX(q1.is_cart) AS viewed_cart,
		MAX(q1.is_shipping) AS viewed_shipping,
        MAX(q1.is_billing) AS viewed_billing,
		MAX(q1.is_billing2) AS viewed_billing2,
		MAX(q1.is_thank_you) AS viewed_thank_you
	FROM
		(SELECT -- building categorical variables to identify each web_pageview_id's url
			website_sessions.website_session_id,
			website_sessions.created_at,
			website_sessions.utm_source,
			CASE WHEN website_pageviews.pageview_url = '/lander-1' THEN 1 ELSE 0 END AS is_lander,
			CASE WHEN website_pageviews.pageview_url = '/products' THEN 1 ELSE 0 END AS is_products,
			CASE WHEN website_pageviews.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS is_mr_fuzzy,
            CASE WHEN website_pageviews.pageview_url = '/cart' THEN 1 ELSE 0 END AS is_cart,
			CASE WHEN website_pageviews.pageview_url = '/shipping' THEN 1 ELSE 0 END AS is_shipping,
            CASE WHEN website_pageviews.pageview_url = '/billing' THEN 1 ELSE 0 END AS is_billing,
			CASE WHEN website_pageviews.pageview_url = '/billing-2' THEN 1 ELSE 0 END AS is_billing2,
			CASE WHEN website_pageviews.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS is_thank_you
		FROM website_pageviews
		LEFT JOIN website_sessions
			ON website_pageviews.website_session_id = website_sessions.website_session_id
		WHERE 
			(website_sessions.created_at BETWEEN '2012-09-09 22:13:04' AND '2012-11-10')
		) AS q1
	GROUP BY q1.website_session_id
	) AS q2 
    WHERE 
    (q2.viewed_billing2 = 1); -- may need to do it so is NOT /billing1