# SQL_Projects

## SQL Project Portfolio

### 🏦 Bank Customer Analysis & KPI Reporting

Tools: SQL (Subqueries, Joins, Aggregations), ER ModelingDatabase Focus: Customer activity datasets (checking + credit card)

Overview

Created a dynamic KPI report to analyze customer engagement across banking products. This involved calculating customer tenure, total active accounts, total assets, and product join dates using normalized datasets.

Key Features

Calculated earliest customer relationship date from multiple tables.

Aggregated total active accounts per client.

Summed assets across different account types, handling both positive and negative balances.

Wrote efficient JOIN and aggregation queries for real-world financial reporting.

### 🛒 Product Sales & POS Analysis

Tools: SQL (CTEs, Aggregates, UNION, Joins)Database Focus: Product sales and POS transaction data across multiple tables

Overview

Analyzed multi-source product sales data by merging and cleaning records. Generated insights such as total and average sales per product, duplicates identification, and transaction-level aggregation across POS systems.

Key Features

Identified and cleaned duplicate entries between product datasets.

Created merged views using UNION and cleaned datasets using DISTINCT.

Generated consolidated sales summaries across three POS tables.

Computed KPIs including total sales, number of transactions, and averages per product.

### 📊 Transaction & Account Management Analytics

Tools: SQL (Window Functions, Joins, Group By, Case Statements)Database Focus: Transaction log and customer account data

Overview

Built queries to classify, summarize, and analyze customer transaction behavior. Derived credit/debit stats, recent account activity, and customer summaries by combining transactional and account-level data.

Key Features

Extracted latest accounts per customer using MAX(create_date).

Classified transaction types as credit or debit with CASE statements.

Joined account and transaction tables to produce unified customer reports.

Handled customers with missing account records using LEFT JOIN logic.

### 📖 Library Management System - Database Design & Querying

Tools: SQL (DDL, DML, Query Logic, Relational Joins)Database Focus: Library management schema design and advanced querying

Overview

Designed and implemented a relational database schema for a library system. Populated tables with sample data and wrote complex SQL queries to simulate real-world operations such as loan tracking, book availability, and borrower behavior.

Key Features

Designed schema with normalized tables (books, authors, branches, borrowers, loans).

Populated database using INSERT statements with realistic values.

Executed complex queries including:

Borrowers by branch

Average copies and loaned books

Books borrowed by author or city

Ranking of library branches based on loan activity

Performed data manipulation tasks: UPDATE branch info, DELETE books by publisher, INSERT new titles.
