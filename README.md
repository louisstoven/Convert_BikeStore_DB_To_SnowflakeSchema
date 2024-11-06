# BikeStore Database Modification

## Overview
This repository contains a modified version of the BikeStore database, which has been redesigned to implement a snowflake schema. The primary goal of this modification is to accelerate query performance and reduce data redundancy.

## Key Changes
Normalization: The database structure has been normalized to create separate dimension and fact tables. This reduces data duplication and ensures a more efficient data model.
Dimension Tables: Created dimension tables for customers, products, suppliers, dates, and stock locations to encapsulate descriptive attributes.
Fact Tables: Established fact tables for purchases, purchase details, deliveries, and supplies, which record quantitative data linked to the dimension tables.
Improved Query Performance: The snowflake schema optimizes the database for complex queries, improving retrieval times and overall performance.

## Schema Structure
### Dimension Tables:

Dim_Customer
Dim_Product
Dim_Supplier
Dim_Date
Dim_StockLocation
Dim_Repair

### Fact Tables:

Fact_Purchases
Fact_PurchaseDetails
Fact_Delivery
Fact_Supplies

## Benefits
Faster Query Execution: With a snowflake schema, queries can be executed more quickly due to the optimized structure.
Less Redundancy: By separating data into different tables, redundancy is minimized, leading to a cleaner and more maintainable database.
Scalability: The new design allows for easier scaling and modifications as business needs evolve.

## Conclusion
The modifications made to the BikeStore database provide a robust framework for data analysis, ensuring high performance and efficient data management. For further details on the schema and queries, refer to the SQL files included in this repository.
