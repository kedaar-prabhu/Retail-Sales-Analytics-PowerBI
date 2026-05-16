# End-to-End Retail Performance Analytics Dashboard

## 📊 Final Interactive Dashboard Interface
![Final Retail Analytics Dashboard](image_16ff37.png)
*Figure 1: The finalized, polished executive view featuring responsive structural slicers, consistent shadow grouping, and dynamic city-wide performance metrics.*
---
## 📐 Backend Data Model (Star Schema)
![Star Schema Data Model](image_177b38.png)
*Figure 2: The production-ready backend layout showcasing normalized dimension tables linking cleanly to the core sales fact table.*

## 📊 Project Overview
This repository contains a comprehensive retail analytics solution designed to transform raw transactional data into actionable business intelligence. Coming from an operational retail background, I built this executive-facing dashboard to analyze how promotional strategies, regional distributions, and store types impact overall business health and revenue generation.

The project handles backend data relations and front-end dashboard architecture, tracking over **1.07 Billion** in total sales and **141 Million** individual customer transactions.

---

## 🛠️ Tech Stack & Skills Demonstrated
* **Power BI Desktop:** Advanced Data Visualization, UI/UX Design, Report Authoring.
* **DAX (Data Analysis Expressions):** Time Intelligence, Dynamic Formatting, Custom Benchmarking.
* **Data Modeling:** Star Schema Design, Relationship Management ($1:N$), Fact/Dimension optimization.
* **SQL:** Initial data exploration, schema definitions, and transactional validation.

---

## 📐 Data Architecture & Modeling
To ensure lightning-fast performance and clean analytical boundaries, the backend is organized into a robust **Star Schema**. 

* **Fact Table:** `sales` (containing transaction amounts, quantities, and promotion markers).
* **Dimension Tables:** * `stores` (Store location, city, type category).
  * `Date_Table` (A dedicated calendar table supporting time-intelligence logic).
  * *Contextual Dimensions:* Integration boundaries for holidays and external economic factors (oil pricing).

*All analytical measures are isolated in a dedicated `_Calculations` table to maintain enterprise-level best practices.*

---

## 🧠 Key DAX Measures Developed

### 1. Dynamic Performance Benchmarking
Used to automate visual alerts on the city-wide sales bar chart. Cities hitting target benchmarks turn green, while trailing regions dynamically alert in orange/red.
```dax
Performance Color = 
IF(
    [Total Sales] >= 50000000, 
    "#1A932E", -- Success Green
    "#FF4A00"  -- Warning Orange
)

## 📈 Dashboard Architecture & Insights
Instead of splitting metrics across multiple pages, I engineered a unified, high-density **Executive & Operational Overview** canvas. This allows stakeholders to cross-reference macroeconomic trends, promotional strategies, and regional performance simultaneously.

### Key Insights Visible at a Glance:
* **The Promo Trap:** A staggering **64.78%** of total revenue is driven entirely by promotional campaigns, indicating a highly price-sensitive consumer market.
* **Regional Disparities:** **Quito** is the absolute market leader, generating **$557M** in sales, vastly outperforming other regions.
* **Store Optimization:** Store categories **A** and **D** make up the lion's share of corporate footprint (over 65% of revenue distribution), meaning resource allocation should prioritize these formats.
* **Basket Metrics:** Across **141 Million transactions**, the business maintains an Average Transaction Value (ATV) of **$7.59**.

---

## 📂 Repository Contents
* `Retail_sales_analysis_project.pbix` - The complete interactive Power BI dashboard file.
* `retail_data_preparation.sql` - The backend SQL script used for data querying, transformation, and structural integrity checks.
* `README.md` - Technical project documentation.
* `image_177b38.png` - The Star Schema Data Model showing entity relationships ($1:N$).
* `image_16ff37.png` - The finalized, polished executive dashboard overview.
---

## 🚀 Future Enhancements
* Incorporate predictive time-series forecasting using Power BI's native AI features to estimate next-quarter demand.
* Append automated ETL automation scripts to pipeline incoming monthly sales data smoothly from the local SQL database.
