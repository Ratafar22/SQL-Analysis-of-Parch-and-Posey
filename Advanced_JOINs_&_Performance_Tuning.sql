-- FUll Outer Join
-- 1. find each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
SELECT *
FROM accounts AS a
FULL OUTER JOIN sales_reps AS s
ON s.id = a.sales_rep_id;

-- 2. but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty
SELECT *
FROM accounts AS a
FULL OUTER JOIN sales_reps AS s
ON s.id = a.sales_rep_id
WHERE a.id = NULL or s.id = NULL;


-- Quiz: JOINs with Comparison Operators
-- write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name
SELECT a.name AS account_name, a.primary_poc, s.name AS sales_rep_name
FROM accounts AS a
LEFT JOIN sales_reps AS s
ON s.id = a.sales_rep_id
AND a.primary_poc < s.name;


-- Quiz: UNION
-- Write a query that uses UNION ALL on two instances (and selecting all columns) of the accounts table.
SELECT *
FROM accounts a1

UNION ALL

SELECT *
FROM accounts a2;

-- Pretreating Tables before doing a UNION
-- Add a WHERE clause to each of the tables that you unioned in the query above, filtering the first table where name equals Walmart and filtering the second table where name equals Disney
SELECT *
FROM accounts a1
WHERE name = 'Walmart'

UNION ALL

SELECT *
FROM accounts a2
WHERE name = 'Disney';