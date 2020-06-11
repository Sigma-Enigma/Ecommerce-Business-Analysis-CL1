-- Identfying Repeat Visitors

-- Count how many visitors came back for another session

-- limit from 2014 to 2014-11-01

USE ecommerce_data;

SELECT *

FROM website_sessions

WHERE created_at BETWEEN '2014-01-01' AND '2014-11-01'
;

-- first find count number of sessios per user ID within this time range
SELECT 
	user_id,
	COUNT(website_session_id) AS sessions
    
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-01'
GROUP BY 1
;


-- next use prior table to count number of user_id's where sessions = 1, sessions = 2 etc. Grouping will be number of sessions-1 (number of repeat sessions)

