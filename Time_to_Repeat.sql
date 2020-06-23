-- Analyzing Time to Repeat

-- minimum maximum and average time to first and second sessions

-- time frame: '2014-01-01' to '2014-11-04'

USE ecommerce_data;

SELECT
	user_id,
	website_session_id,
	created_at,
    is_repeat_session

FROM website_sessions

WHERE created_at BETWEEN '2014-01-01' AND '2014-11-04'
ORDER BY user_id ASC, created_at ASC
;

-- few ways to do it
-- make temp tables with first visit, second visit, third etc... (do this by taking the row with the minimum time per user_id and extract it; then repeat for the remaining values to get 2nd min)
-- then using website session ID, ladd all repeat values and their created_at times onto one table linking by user_id
-- then use timediff() function to calculate   


SELECT
	ws1.user_id,
	MIN(ws1.website_session_id) first_ws_id,
    MIN(ws1.created_at) AS first_ws_time

FROM website_sessions AS ws1
    
WHERE ws1.created_at BETWEEN '2014-01-01' AND '2014-11-04'

GROUP BY ws1.user_id
ORDER BY ws1.user_id ASC
; -- using website_session_id antijoin to remove 2nd table session_ids from original table, then find use min to find 2nd min and store as 3rd table


CREATE TEMPORARY TABLE t1
SELECT
	ws1.user_id AS user_id,
	MIN(ws1.website_session_id) first_ws_id,
    MIN(ws1.created_at) AS first_ws_time

FROM website_sessions AS ws1
    
WHERE ws1.created_at BETWEEN '2014-01-01' AND '2014-11-04'

GROUP BY ws1.user_id
ORDER BY ws1.user_id ASC
;



SELECT
	website_sessions.user_id,
    website_sessions.website_session_id,
    website_sessions.created_at,
    website_sessions.is_repeat_session
    
FROM website_sessions
LEFT JOIN t1
	ON t1.first_ws_id = website_sessions.website_session_id

WHERE 
	t1.first_ws_id IS NULL
	AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-04'
ORDER BY website_sessions.user_id ASC, website_sessions.website_session_id ASC
;

CREATE TEMPORARY TABLE t2
SELECT
	website_sessions.user_id,
	website_sessions.website_session_id,
    website_sessions.created_at,
    website_sessions.is_repeat_session
    
FROM website_sessions
LEFT JOIN t1
	ON t1.first_ws_id = website_sessions.website_session_id

WHERE 
	t1.first_ws_id IS NULL
	AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-04'
ORDER BY website_sessions.user_id ASC, website_sessions.website_session_id ASC
;


SELECT
	ws2.user_id AS user_id,
	MIN(ws2.website_session_id) second_ws_id,
    MIN(ws2.created_at) AS second_ws_time

FROM t2 AS ws2
    
WHERE ws2.created_at BETWEEN '2014-01-01' AND '2014-11-04'

GROUP BY ws2.user_id
ORDER BY ws2.user_id ASC
;

CREATE TEMPORARY TABLE t3
SELECT
	ws2.user_id AS user_id,
	MIN(ws2.website_session_id) second_ws_id,
    MIN(ws2.created_at) AS second_ws_time

FROM t2 AS ws2
    
WHERE ws2.created_at BETWEEN '2014-01-01' AND '2014-11-04'

GROUP BY ws2.user_id
ORDER BY ws2.user_id ASC
;

SELECT
	t2.user_id,
	t2.website_session_id,
    t2.created_at,
    t2.is_repeat_session
    
FROM t2
LEFT JOIN t3
	ON t3.second_ws_id = t2.website_session_id

WHERE 
	t3.second_ws_id IS NULL
	AND t2.created_at BETWEEN '2014-01-01' AND '2014-11-04'
ORDER BY t2.user_id ASC, t2.website_session_id ASC
;

CREATE TEMPORARY TABLE t4
SELECT
	t2.user_id,
	t2.website_session_id,
    t2.created_at,
    t2.is_repeat_session
    
FROM t2
LEFT JOIN t3
	ON t3.second_ws_id = t2.website_session_id

WHERE 
	t3.second_ws_id IS NULL
	AND t2.created_at BETWEEN '2014-01-01' AND '2014-11-04'
ORDER BY t2.user_id ASC, t2.website_session_id ASC
;

SELECT
	ws3.user_id AS user_id,
	MIN(ws3.website_session_id) third_ws_id,
    MIN(ws3.created_at) AS third_ws_time

FROM t4 AS ws3
    
WHERE ws3.created_at BETWEEN '2014-01-01' AND '2014-11-04'

GROUP BY ws3.user_id
ORDER BY ws3.user_id ASC
;

CREATE TEMPORARY TABLE t5
SELECT
	ws3.user_id AS user_id,
	MIN(ws3.website_session_id) third_ws_id,
    MIN(ws3.created_at) AS third_ws_time

FROM t4 AS ws3
    
WHERE ws3.created_at BETWEEN '2014-01-01' AND '2014-11-04'

GROUP BY ws3.user_id
ORDER BY ws3.user_id ASC
;

SELECT
	t4.user_id,
	t4.website_session_id,
    t4.created_at,
    t4.is_repeat_session
    
FROM t4
LEFT JOIN t5
	ON t5.third_ws_id = t4.website_session_id

WHERE 
	t5.third_ws_id IS NULL
	AND t4.created_at BETWEEN '2014-01-01' AND '2014-11-04'
ORDER BY t4.user_id ASC, t4.website_session_id ASC
;

CREATE TEMPORARY TABLE t6
SELECT
	t4.user_id,
	t4.website_session_id,
    t4.created_at,
    t4.is_repeat_session
    
FROM t4
LEFT JOIN t5
	ON t5.third_ws_id = t4.website_session_id

WHERE 
	t5.third_ws_id IS NULL
	AND t4.created_at BETWEEN '2014-01-01' AND '2014-11-04'
ORDER BY t4.user_id ASC, t4.website_session_id ASC
;

SELECT
	ws4.user_id AS user_id,
	MIN(ws4.website_session_id) fourth_ws_id,
    MIN(ws4.created_at) AS fourth_ws_time

FROM t6 AS ws4
    
WHERE ws4.created_at BETWEEN '2014-01-01' AND '2014-11-04'

GROUP BY ws4.user_id
ORDER BY ws4.user_id ASC
;

CREATE TEMPORARY TABLE t7
SELECT
	ws4.user_id AS user_id,
	MIN(ws4.website_session_id) fourth_ws_id,
    MIN(ws4.created_at) AS fourth_ws_time

FROM t6 AS ws4
    
WHERE ws4.created_at BETWEEN '2014-01-01' AND '2014-11-04'

GROUP BY ws4.user_id
ORDER BY ws4.user_id ASC
;

SELECT
	t6.user_id,
	t6.website_session_id,
    t6.created_at,
    t6.is_repeat_session
    
FROM t6
LEFT JOIN t7
	ON t7.fourth_ws_id = t6.website_session_id

WHERE 
	t7.fourth_ws_id IS NULL
	AND t6.created_at BETWEEN '2014-01-01' AND '2014-11-04'
ORDER BY t6.user_id ASC, t6.website_session_id ASC
;

CREATE TEMPORARY TABLE t8
SELECT
	t6.user_id,
	t6.website_session_id,
    t6.created_at,
    t6.is_repeat_session
    
FROM t6
LEFT JOIN t7
	ON t7.fourth_ws_id = t6.website_session_id

WHERE 
	t7.fourth_ws_id IS NULL
	AND t6.created_at BETWEEN '2014-01-01' AND '2014-11-04'
ORDER BY t6.user_id ASC, t6.website_session_id ASC
;

SELECT
	ws5.user_id AS user_id,
	MIN(ws5.website_session_id) fifth_ws_id,
    MIN(ws5.created_at) AS fifth_ws_time

FROM t8 AS ws5
    
WHERE ws5.created_at BETWEEN '2014-01-01' AND '2014-11-04'

GROUP BY ws5.user_id
ORDER BY ws5.user_id ASC
;

CREATE TEMPORARY TABLE t9
SELECT
	ws5.user_id AS user_id,
	MIN(ws5.website_session_id) fifth_ws_id,
    MIN(ws5.created_at) AS fifth_ws_time

FROM t8 AS ws5
    
WHERE ws5.created_at BETWEEN '2014-01-01' AND '2014-11-04'

GROUP BY ws5.user_id
ORDER BY ws5.user_id ASC
;

SELECT
	t8.user_id,
	t8.website_session_id,
    t8.created_at,
    t8.is_repeat_session
    
FROM t8
LEFT JOIN t9
	ON t9.fifth_ws_id = t8.website_session_id

WHERE 
	t9.fifth_ws_id IS NULL
	AND t8.created_at BETWEEN '2014-01-01' AND '2014-11-04'
ORDER BY t8.user_id ASC, t8.website_session_id ASC
;

CREATE TEMPORARY TABLE t10
SELECT
	t8.user_id,
	t8.website_session_id,
    t8.created_at,
    t8.is_repeat_session
    
FROM t8
LEFT JOIN t9
	ON t9.fifth_ws_id = t8.website_session_id

WHERE 
	t9.fifth_ws_id IS NULL
	AND t8.created_at BETWEEN '2014-01-01' AND '2014-11-04'
ORDER BY t8.user_id ASC, t8.website_session_id ASC
;

SELECT COUNT(*)
FROM t2
;

SELECT COUNT(*)
FROM t4
;

SELECT COUNT(*)
FROM t6
;

SELECT COUNT(*)
FROM t8
;

SELECT COUNT(*)
FROM t10
;




-- as we can see there were no 5th sessions
-- now I need to find a way to aggregate the values

SELECT
	AVG( t4.created_at - t2.created_at )/(60*60*24) AS avg_days_first_to_second,
    MIN( t4.created_at - t2.created_at )/(60*60*24) AS min_days_first_to_second,
	MAX( t4.created_at - t2.created_at )/(60*60*24) AS max_days_first_to_second

FROM t2
LEFT JOIN t4
	ON t4.user_id = t2.user_id
;


SELECT
	t2.user_id AS second_user_id,
    website_sessions.user_id AS first_user_id,
    t2.website_session_id AS second_web_id,
    website_sessions.website_session_id AS first_web_id,
	t2.created_at AS second_session,
    website_sessions.created_at AS first_session,
    t2.created_at - website_sessions.created_at AS time_diff,
    (t2.created_at - website_sessions.created_at)/(60*60*24) AS time_diff2,
    DATEDIFF(t2.created_at, website_sessions.created_at) AS time_diff3
    
FROM t2
LEFT JOIN website_sessions
	ON website_sessions.user_id = t2.user_id AND website_sessions.is_repeat_session = 0
; -- preping tables for aggregate functions

CREATE TEMPORARY TABLE tfinal
SELECT
	t2.user_id AS second_user_id,
    website_sessions.user_id AS first_user_id,
    t2.website_session_id AS second_web_id,
    website_sessions.website_session_id AS first_web_id,
	t2.created_at AS second_session,
    website_sessions.created_at AS first_session,
    t2.created_at - website_sessions.created_at AS time_diff,
    (t2.created_at - website_sessions.created_at)/(60*60*24) AS time_diff2,
    DATEDIFF(t2.created_at, website_sessions.created_at) AS time_diff3
    
FROM t2
LEFT JOIN website_sessions
	ON website_sessions.user_id = t2.user_id AND website_sessions.is_repeat_session = 0
; 

SELECT
	AVG( tfinal.time_diff3 ) AS avg_days_first_to_second,
    MIN( tfinal.time_diff3 ) AS min_days_first_to_second,
	MAX( tfinal.time_diff3 ) AS max_days_first_to_second

FROM tfinal
; -- check table values before merge for tfinal to ensure the proper rows were queried


-- 
-- note only needed first repeat... thus we can just use the is_repeat_session variable and find min website_session_id, all my work above was in the case of finding subsequent repeats

    


DROP TABLE t1; -- now take min of this one to get table of 2nd mins
DROP TABLE t2; -- 
DROP TABLE t3;
DROP TABLE t4;
DROP TABLE t5;
DROP TABLE t6;
DROP TABLE t7;
DROP TABLE t8;
DROP TABLE t9;
DROP TABLE t10;
DROP TABLE tfinal;



