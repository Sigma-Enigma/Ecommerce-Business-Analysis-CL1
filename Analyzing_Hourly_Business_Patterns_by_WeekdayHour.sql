-- Analyzing Hourly Business Patterns by Weekday

USE ecommerce_data;


CREATE TEMPORARY TABLE hr_counts

SELECT

HOUR(website_sessions.created_at) AS hr,
MIN( TIME(website_sessions.created_at) ) AS min_time,
COUNT( CASE WHEN weekday(website_sessions.created_at) = '0' THEN website_sessions.website_session_id ELSE NULL END ) AS mon,
COUNT( CASE WHEN weekday(website_sessions.created_at) = '1' THEN website_sessions.website_session_id ELSE NULL END ) AS tue,
COUNT( CASE WHEN weekday(website_sessions.created_at) = '2' THEN website_sessions.website_session_id ELSE NULL END ) AS wed,
COUNT( CASE WHEN weekday(website_sessions.created_at) = '3' THEN website_sessions.website_session_id ELSE NULL END ) AS thu,
COUNT( CASE WHEN weekday(website_sessions.created_at) = '4' THEN website_sessions.website_session_id ELSE NULL END ) AS fri,
COUNT( CASE WHEN weekday(website_sessions.created_at) = '5' THEN website_sessions.website_session_id ELSE NULL END ) AS sat,
COUNT( CASE WHEN weekday(website_sessions.created_at) = '6' THEN website_sessions.website_session_id ELSE NULL END ) AS sun


FROM website_sessions

WHERE website_sessions.created_at BETWEEN '2012-09-15' AND '2012-11-15'

GROUP BY hr
ORDER BY hr ASC;



SELECT 

MAX(mon) AS mon_pct_max,
MAX(tue) AS tue_pct_max,
MAX(wed) AS wed_pct_max,
MAX(thu) AS thu_pct_max,
MAX(fri) AS fri_pct_max,
MAX(sat) AS sat_pct_max,
MAX(sun) AS sun_pct_max

FROM hr_counts

ORDER BY hr;




SELECT 

hr,
min_time,
mon,
ROUND( mon / 204, 2) AS mon_pct,
tue,
ROUND( tue / 214, 2) AS tue_pct,
wed,
ROUND( wed / 223, 2) AS wed_pct,
thu,
ROUND( thu / 194, 2) AS thu_pct,
fri,
ROUND( fri / 175, 2) AS fri_pct,
sat,
ROUND( sat / 80, 2) AS sat_pct,
sun,
ROUND( sun / 89, 2) AS sun_pct

FROM hr_counts


ORDER BY hr ASC;

DROP TABLE hr_counts;