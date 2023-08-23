# SQL-Analysis-of-Parch & Posey

## Introduction
I queried the Parch and Posey paper company database using MySQL and PostgreSQL. Parch and Posey is an online papaer company that deals in the sales of different types of paper (Standard, Poster and Gloss). It is worthy to note that this dataset does not represent a real company. It was developed for the purpose of learning. 

The database consists of 5 tables namely:
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

1. Basic SQL

These includes using syntax such as SELECT, FROM, WHERE, ORDERBY, IN, LIKE, AND, & LIMIT

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
