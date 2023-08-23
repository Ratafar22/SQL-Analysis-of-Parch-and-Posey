# SQL-Analysis-of-Parch & Posey

## Introduction
I queried the Parch and Posey paper company database using MySQL and PostgreSQL. Parch and Posey is an online papaer company that deals in the sales of different types of paper (Standard, Poster and Gloss). It is worthy to note that this dataset does not represent a real company. It was developed for the purpose of learning. 

The database consists of over 15000 rows and 5 different tables namely:
- Orders
- Accounts
- Web_events
- Sales_reps
- Region

Below is the Schema of the database
![](Parch&Posey_Schema.png)

## Analysis Process

I created the database in MySQL workbench for analysis. The query for creating the database can be copied from [Parch&Posey_database](https://github.com/Ratafar22/SQL-Analysis-of-Parch-and-Posey/blob/main/Parch%26Posey-database.sql) and you can load it into any server of your choice. Note: you might need to tweak the syntax to suit the database you are using.

## Skills and Concepts Demonstrated

1. **Basic SQL**

These includes using syntax such as SELECT, FROM, WHERE, ORDERBY, IN, BETWEEN, LIKE, AND, & LIMIT

Some examples are shown below

 ``` sql
-- select only the id, account_id, and occurred_at columns for all orders in the orders table. show the first 10 rows

SELECT id, account_id, occurred_at 
FROM orders
LIMIT 10;

-- Use the web_events table to find all information regarding individuals who were contacted via the organic or adwords channels, 
-- and started their account at any point in 2016, sorted from newest to oldest.

SELECT *
FROM web_events
WHERE channel IN('organic', 'adwords') 
AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;
```
While developing these basic queries, I also demonstrated how to write sql queries in python environment. This is useful when you want to display the output of each query in the next cell. 
To do this, I made used of Jupyter notebook to write my sql queries and the steps needed to follow is shown below

- install ipython-sql libaray using the syntax
  
    **pip install ipython-sql**

- Load External SQL Module

    **%load_ext sql**
  
- Now Connect to the Database
 
    **%sql mysql+pymysql://username:password@localhost/database_name** for mysql

    **sqlite:///yourdatabase.sqlite** for Sqlite

    **postgres://name:password@localhost:6259/database_name** or
  
    **postgres://localhost:6259/database_name** for postgre

After successfully connecting to the database, one can now start writing sql queries in the python environment but note that one needs to start all your queries with **%sql** or **%%sql** as demonstrated below
``` sql
-- select all columns from the orders table

%%sql
    SELECT * 
    FROM orders;
```
For more examples on how the queries and output look like in python, check out my [Basic_SQL](https://github.com/Ratafar22/SQL-Analysis-of-Parch-and-Posey/blob/main/Basic_SQL_Parch_Posey.ipynb)


2. **Aggregations funtions** : These functions are used to summarise data. They include SUM, COUNT, MIN, MAX, AVG, GROUPBY, HAVING etc

Examples:

```sql
--Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.

SELECT	AVG(standard_amt_usd) Avg_standard_amt,
		AVG(gloss_amt_usd) Avg_gloss_amt,
       	AVG(poster_amt_usd) Avg_poster_amt,
        AVG(standard_qty) Avg_standard_qty,
		AVG(gloss_qty) Avg_gloss_qty,
       	AVG(poster_qty) Avg_poster_qty
FROM orders;

--  Find the total sales in usd for each account.

SELECT a.name, SUM(o.total_amt_usd) total_sales_usd
FROM accounts a
JOIN orders o 
ON o.account_id = a.id
GROUP BY a.name;
```
Find more examples of queries in which I used other Aggregation functions [SQl_Aggregations](https://github.com/Ratafar22/SQL-Analysis-of-Parch-and-Posey/blob/main/Aggregations.sql)


3. **JOINS:**  
4. 
