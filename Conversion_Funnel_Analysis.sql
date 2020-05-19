-- Conversion Funnel Analysis

USE ecommerce_data;

-- Webpage funnel by session counts
(
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
    SUM( q2.viewed_billing) AS to_billing,
    SUM( q2.viewed_billing) / SUM( q2.viewed_shipping) AS ctr_to_billing,
    SUM( q2.viewed_thank_you) AS to_thank_you,
    SUM( q2.viewed_thank_you ) / SUM( q2.viewed_billing) AS ctr_to_thank_you
    
FROM
	(SELECT
		q1.website_session_id,
		MAX(q1.is_lander) AS viewed_lander,
		MAX(q1.is_products) AS viewed_products,
		MAX(q1.is_mr_fuzzy) AS viewed_mr_fuzzy,
        MAX(q1.is_cart) AS viewed_cart,
		MAX(q1.is_shipping) AS viewed_shipping,
		MAX(q1.is_billing) AS viewed_billing,
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
			CASE WHEN website_pageviews.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS is_thank_you
		FROM website_pageviews
		LEFT JOIN website_sessions
			ON website_pageviews.website_session_id = website_sessions.website_session_id
		WHERE 
			(website_sessions.created_at BETWEEN '2012-08-05' AND '2012-09-05') 
            AND (website_sessions.utm_source = 'gsearch')  
            AND (website_sessions.utm_campaign = 'nonbrand')
		) AS q1
	GROUP BY q1.website_session_id
	) AS q2 
    WHERE q2.viewed_lander = 1
)

UNION

--  Webpage funnel analysis by clickthrough rate
(
SELECT
	SUM( q2.viewed_lander) / COUNT( q2.website_session_id) AS ctr_to_lander,
	SUM( q2.viewed_products) / SUM( q2.viewed_lander) AS ctr_to_products,
    SUM( q2.viewed_mr_fuzzy) / SUM( q2.viewed_products) AS ctr_to_mr_fuzzy,
    SUM( q2.viewed_cart) / SUM( q2.viewed_mr_fuzzy) AS ctr_to_cart,
    SUM( q2.viewed_shipping) / SUM( q2.viewed_cart) AS ctr_to_shipping,
    SUM( q2.viewed_billing) / SUM( q2.viewed_shipping) AS ctr_to_billing,
    SUM( q2.viewed_thank_you ) / SUM( q2.viewed_billing) AS ctr_to_thank_you
FROM
	(SELECT
		q1.website_session_id,
		MAX(q1.is_lander) AS viewed_lander,
		MAX(q1.is_products) AS viewed_products,
		MAX(q1.is_mr_fuzzy) AS viewed_mr_fuzzy,
        MAX(q1.is_cart) AS viewed_cart,
		MAX(q1.is_shipping) AS viewed_shipping,
		MAX(q1.is_billing) AS viewed_billing,
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
			CASE WHEN website_pageviews.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS is_thank_you
		FROM website_pageviews
		LEFT JOIN website_sessions
			ON website_pageviews.website_session_id = website_sessions.website_session_id
		WHERE 
			(website_sessions.created_at BETWEEN '2012-08-05' AND '2012-09-05') 
            AND (website_sessions.utm_source = 'gsearch')  
            AND (website_sessions.utm_campaign = 'nonbrand')
		) AS q1
	GROUP BY q1.website_session_id
	) AS q2
    WHERE q2.viewed_lander = 1
    ) ;