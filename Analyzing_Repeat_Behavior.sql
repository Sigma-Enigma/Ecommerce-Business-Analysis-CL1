-- Analyzing Repeat Behaviors


-- how many customers come back for another session from 2014 to nov 1 2014

-- he wants rows for number of repeat sessions, and columns aggregate of the number of  sessions

-- first lets get the counts of each user ID

-- then lets count the totals grouping by number of repeated sessions



USE ecommerce_data;

CREATE TABLE repeat_table

SELECT

	user_id AS user_id,
    COUNT( user_id ) -1 AS repeats

FROM website_sessions

WHERE created_at BETWEEN '2014-01-01 00:00:01' AND '2014-11-01'

GROUP BY user_id


ORDER BY user_id;


SELECT 

	repeat_table.repeats AS repeated_sessions,
    COUNT( DISTINCT website_sessions.user_id ) AS users

FROM website_sessions
LEFT JOIN repeat_table
	ON website_sessions.user_id = repeat_table.user_id

WHERE website_sessions.created_at BETWEEN '2014-01-01 00:00:01' AND '2014-11-01'

GROUP BY repeat_table.repeats

ORDER BY repeat_table.repeats ASC;

DROP TABLE repeat_table;
