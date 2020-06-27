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
	WHEN utm_campaign LIKE 'nonbrand'   THEN 'paid_nonbrand'
	WHEN utm_campaign LIKE 'brand'      THEN 'paid_brand'
    WHEN utm_source   LIKE 'socialbook' THEN 'paid_social'
	ELSE 'ERROR' END AS channel_group

FROM website_sessions

WHERE created_at BETWEEN '2014-01-01' AND '2014-11-05'
;

-- null http_referer = direct_type_in
-- null utm_campaign and non-null http_referer = organic_search
-- create new column using case 

SELECT *
FROM t1
WHERE channel_group LIKE 'paid_social'
;

SELECT
	channel_group,
	COUNT(CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS new_sessions,
    COUNT(CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
FROM t1
GROUP BY 1
ORDER BY repeat_sessions DESC
;


-- paid brand and nonbrand groups not showing for some reason, wrong variable name doh!

DROP TABLE t1;