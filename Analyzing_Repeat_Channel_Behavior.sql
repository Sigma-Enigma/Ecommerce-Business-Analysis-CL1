-- Analyzing Repeat Channel Behavior 


USE ecommerce_data;

SELECT
user_id,
website_session_id,
created_at,
is_repeat_session,
utm_source,
utm_campaign,
http_referer,
CASE 
	WHEN (http_referer IS NULL) AND (utm_campaign IS NULL) THEN 'direct_type_in' 
	WHEN (http_referer IS NOT NULL) AND (utm_campaign IS NULL) THEN 'organic_search'
	WHEN (utm_campaign LIKE '%nonbrand%' )  THEN 'paid_nonbrand'
	WHEN (utm_campaign LIKE '%brand%' )  THEN 'paid_brand'
	ELSE 'paid_social' END AS channel_group

FROM website_sessions

WHERE created_at BETWEEN '2014-01-01' AND '2014-11-05'
;

CREATE TEMPORARY TABLE t1
SELECT
user_id,
website_session_id,
created_at,
is_repeat_session,
utm_source,
utm_campaign,
http_referer,
CASE 
	WHEN (http_referer IS NULL) AND (utm_campaign IS NULL) THEN 'direct_type_in' 
	WHEN (http_referer IS NOT NULL) AND (utm_campaign IS NULL) THEN 'organic_search'
	WHEN http_referer LIKE '%nonbrand%' THEN 'paid_nonbrand'
	WHEN http_referer LIKE '%brand%'   THEN 'paid_brand'
	ELSE 'paid_social' END AS channel_group

FROM website_sessions

WHERE created_at BETWEEN '2014-01-01' AND '2014-11-05'
;

-- null http_referer = direct_type_in
-- null utm_campaign and non-null http_referer = organic_search
-- create new column using case 


SELECT
	channel_group,
	COUNT(website_session_id) AS counts
FROM t1
GROUP BY 1
;

DROP TABLE t1;