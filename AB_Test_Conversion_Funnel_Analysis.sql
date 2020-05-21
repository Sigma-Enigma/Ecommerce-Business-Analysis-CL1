-- AB Test Conversion Funnel Analysis

-- Fixed query

USE ecommerce_data;

SELECT  -- query to determine when new billing-2 page went live to limit comparison dates
	website_pageview_id,
    pageview_url,
    created_at
FROM website_pageviews
WHERE pageview_url = '/billing-2'
ORDER BY created_at ASC
LIMIT 500; -- earliest date '2012-09-09 22:13:04'


 -- use orders table not website pageviews to determine if purchased
 
SELECT
    SUM( q2.viewed_billing) AS to_billing,
    SUM( q2.viewed_order) AS to_order,
    SUM( q2.viewed_order) / SUM( q2.viewed_billing) AS ctr_to_order
FROM
	(SELECT -- column with indicator variable if they viewed billing page and if they ordered
		q1.website_session_id,
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
    (q2.viewed_billing = 1 ); 
    
SELECT
    SUM( q2.viewed_billing2) AS to_billing2,
    SUM( q2.viewed_order) AS to_order,
    SUM( q2.viewed_order) / SUM( q2.viewed_billing2) AS ctr_to_order
FROM
	(SELECT -- column with indicator variable if they viewed billing page and if they ordered
		q1.website_session_id,
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
    (q2.viewed_billing2 = 1); 
    
    -- note: if you wanted to speed the query instead of repeating the inner queries, simply collapse the second table into the first by adding new columns in the outermost select command