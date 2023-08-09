-- LEFT & RIGHT Quizzes
-- 1. In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. Pull these extensions and provide how many of each website type exist in the accounts table.
SELECT RIGHT(website,3) AS Extension,
COUNT(*) AS num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

-- 2. There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
                    
SELECT UPPER(LEFT(name,1)) AS first_letter,
COUNT(*) number
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;
           
-- 3. Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?
SELECT SUM(num) num, SUM(letter) letter
FROM(SELECT CASE 
             WHEN UPPER(LEFT(name,1)) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 ELSE 0 END AS num,
			CASE
       			WHEN UPPER(LEFT(name,1)) IN ('0','1','2','3','4','5','6','7','8','9') THEN 0 ELSE 1 END AS letter
  	FROM accounts) sub;
           
-- 4. Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
SELECT SUM(vowel) AS vowel, SUM(others) AS others 
FROM(SELECT CASE 
       		WHEN UPPER(LEFT(name,1)) IN ('A','E','I','O','U') THEN 1 ELSE 0 END AS vowel,
       CASE 
           WHEN UPPER(LEFT(name,1)) IN ('A','E','I','O','U') THEN 0 ELSE 1 END AS others
	FROM accounts)sub;
    
-- Quizzes POSITION & STRPOS
-- 1. Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
SELECT LEFT(primary_poc,STRPOS(primary_poc,' ')-1) AS first_name, -- postgre syntax
RIGHT(primary_poc, LENGTH(Primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
FROM accounts;
SELECT LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,   -- STRPOS doesn't work in Mysql except POSITION
RIGHT(primary_poc, LENGTH(Primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
FROM accounts;
                                                  
-- 2. Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
SELECT LEFT(name,STRPOS(name,' ')-1) AS first_name, -- postgre syntax
RIGHT(name, LENGTH(name) - POSITION(' ' IN name)) AS last_name
FROM sales_reps;              
SELECT LEFT(name, POSITION(' ' IN name)-1) AS first_name,    -- Mysql syntax
RIGHT(name, LENGTH(name) - POSITION(' ' IN name)) AS last_name
FROM sales_reps; 				

-- Quizzes CONCAT
-- 1. Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
WITH sub1 AS(
	SELECT name, LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name, RIGHT(primary_poc, LENGTH(Primary_poc) - POSITION(' ' IN primary_poc)) AS last_name FROM accounts )
SELECT first_name, last_name, CONCAT(first_name,('.'), last_name, '@', name, '.com') AS email_address
FROM sub1;

-- 2. You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 1
WITH sub1 AS(
	SELECT name, LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name, RIGHT(primary_poc, LENGTH(Primary_poc) - POSITION(' ' IN primary_poc)) AS last_name FROM accounts )
SELECT first_name, last_name, CONCAT(first_name,('.'), last_name, '@', TRIM(name), '.com') AS email_address
FROM sub1;

-- 3. We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.
WITH sub1 AS(                                                   
	SELECT name, LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
	FROM accounts)      
SELECT first_name, last_name,
LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '') AS password
FROM sub1;

 WITH sub1 AS(                                                   
	SELECT name, LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
	FROM accounts)      
SELECT first_name, last_name,
CONCAT(LEFT(LOWER(first_name), 1), RIGHT(LOWER(first_name), 1), LEFT(LOWER(last_name), 1), RIGHT(LOWER(last_name), 1), LENGTH(first_name), LENGTH(last_name), REPLACE(UPPER(name), ' ', '')) AS password
FROM sub1;