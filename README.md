# Maven Fuzzy Factory — SQL Growth Analysis

A data-driven business analysis of a fictional eCommerce startup using advanced MySQL techniques. This project was completed as the final project of the **Advanced SQL for Ecommerce Data Analysis** course by Maven Analytics (Udemy).

---

## Project Background

In this project I am a **Database Analyst** at Maven Fuzzy Factory tasked with analyzing business performance from launch through the most recent quarter to build a data-driven growth story for investors.

---

## The Growth Story at a Glance

| Theme | Evidence |
|---|---|
| Sustained growth | Sessions and orders rose every quarter |
| Improving efficiency | CVR, revenue per order, and revenue per session all trended upward |
| Diversified acquisition | Organic and direct traffic channels grew alongside paid search |
| Product expansion worked | Each new product launch added incremental revenue and margin |
| Website optimization works | Product page CTR and order conversion rates improved month over month |
| Cross-sell opportunity identified | Post-4th-product data revealed actionable upsell options |

---

## Questions Answered

### Q1 — Overall Session & Order Volume Growth by Quarter
Pulled total website sessions and orders for every quarter since launch to demonstrate sustained, consistent scaling of the business.

### Q2 — Efficiency Improvements by Quarter
Tracked session to order conversion rate, revenue per order, and revenue per session quarterly to show the business was not just growing in volume but improving in efficiency over time.

### Q3 — Orders by Traffic Channel, by Quarter
Broke down quarterly orders across five acquisition channels: gsearch nonbrand, bsearch nonbrand, brand search, organic search, and direct type-in to reveal how the channel mix evolved over time.

### Q4 — Session-to-Order CVR by Channel, by Quarter
Measured conversion rate by channel per quarter to identify which channels improved most and connect those gains to specific marketing optimizations.

### Q5 — Monthly Revenue & Profit Margin by Product
Tracked monthly revenue and profit margin for each of the four products (Original Fuzzy Bear, Love Bear, Sugar Panda, Hudson River Bear) alongside total revenue and margin to show the impact of product expansion.

### Q6 — Product Page Click-Through & Conversion Rate (Monthly)
Analyzed the `/products` page funnel monthly, measuring click-through rate to product pages and overall product to order conversion rate using a multi-CTE approach.

### Q7 — Cross-Sell Analysis After 4th Product Launch
After the Hudson River Bear launched on December 5, 2014, analyzed cross-sell rates between all four products to identify which pairings drove the most add-on purchases.

---

## Key SQL Techniques Used

- `JOIN` — combining session, pageview, and order data across multiple tables
- Aggregate functions — `COUNT`, `SUM`, `ROUND`, `MIN`, `MAX`
- `CASE WHEN` — conditional aggregation for channel segmentation
- `GROUP BY` with `YEAR()`, `QUARTER()`, `MONTH()`
- CTEs (`WITH`) — multi-step funnel logic for pageview and cross-sell analysis
- `NULLIF()` — division by zero protection in conversion rate calculations
- `LEFT JOIN` — preserving all sessions regardless of whether an order occurred

---

## Database Tables

| Table | Description |
|---|---|
| `website_sessions` | One row per user session; includes UTM / traffic source data |
| `website_pageviews` | One row per page viewed within a session |
| `orders` | One row per completed order |
| `order_items` | One row per product within an order; includes revenue and COGS |

---

## Files in This Repository

| File | Description |
|---|---|
| `maven_fuzzy_factory_analysis.sql` | Fully narrated SQL script with business context, query logic, and findings |
| `README.md` | This file |

---

## Tools & Skills

- **MySQL / MySQL Workbench** — query development and execution
- **VS Code** — script editing and formatting
- **Advanced SQL** — CTEs, conditional aggregation, funnel analysis, time-series trending

---

## Course Reference

> **Advanced SQL for Ecommerce Data Analysis**
> Maven Analytics — available on Udemy
> *All data is from a custom-built fictional eCommerce database designed for educational use.*

---

## Author

**Logan Kirby**
[[LinkedIn](https://www.linkedin.com/in/logan-kirby-5ba2421b5/)]
