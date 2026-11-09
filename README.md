# SQL Portfolio

SQL projects completed in Google BigQuery as part of the Data Analytics course at Mate Academy. The queries analyze e-commerce and email marketing data: user sessions, orders, accounts, and email activity.

Skills: window functions, CTEs, multi-table JOINs, UNION, conditional aggregation, date functions, ranking.

---

## 1. Email Activity & Account Metrics by Country — final_project.sql
Task: Build a combined dataset of account creation and email activity (sent, opened, visited) by date, country, and account attributes, then identify the top 10 countries by number of accounts and emails sent.

Techniques: multiple CTEs, JOINs across 4+ tables, UNION, window functions, RANK.

## 2. Revenue and Account Metrics by Continent — revenue_by_device_continent.sql
Task: For each continent, calculate total revenue, revenue from mobile and desktop devices, share of total revenue, number of accounts, verified accounts, and sessions.

Techniques: multiple CTEs, JOINs, conditional aggregation (SUM/COUNT with CASE WHEN), COUNT DISTINCT.

## 3. Prediction Fulfillment — prediction_fulfillment_cte.sql
Task: Compare actual cumulative daily revenue with cumulative revenue targets and calculate the fulfillment percentage.

Techniques: CTEs, UNION ALL, running totals with window functions.

## 4. Emails Sent by Month — emails_sent_by_month.sql
Task: For each account and month, calculate its share of all emails sent that month, plus the first and last send dates — using only window functions, without GROUP BY.

Techniques: window functions (COUNT, MIN, MAX OVER PARTITION BY), DATE_TRUNC, DATE_ADD.

---

## About me
Career changer from biology teaching and psychology into data analytics — bringing an understanding of people and behavior to data work. Based in Poland.
