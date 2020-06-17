-- Analyzing Time to Repeat

-- minimum maximum and average time to first and second sessions

-- time frame: '2014-01-01' to '2014-11-04'

USE ecommerce_data;

SELECT
	user_id,
	website_session_id,
	created_at

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
