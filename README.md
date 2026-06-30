## Tech Stack & Tools Used

* *Data Extraction & Analysis:* Python (BeautifulSoup / Requests ), Pandas, NumPy
* *Database Management:* SQL Server (MYSQL)
* *Business Intelligence:* Power BI Desktop
* *Architectural Concepts:* Star Schema Modeling, ETL, Data Normalization,DAX

## 📂 Project Architecture & Implementation Details

### 🔹 Step 1: Python – Web Scraping & Exploratory Data Analysis (EDA)
The pipeline begins by programmatically harvesting raw unstructured/semi-structured data from an e-commerce platform and refining it for downstream analytical usage.
* *Web Scraping:* Developed dynamic Python scripts using libraries like BeautifulSoup to bypass rendering layers and extract core properties such as Product_Name, raw transaction prices, customer review thresholds, rating distributions, and order metrics.
* *Exploratory Data Analysis (EDA):* Leveraged Pandas and NumPy to inspect data distribution, handle missing values, drop duplicate entries, and clean up anomalies. Performed data type casting (e.g., stripping text formatting from currency strings to create clean numeric floats) to prepare features for relational insertion.

### 🔹 Step 2: SQL Server – Relational Star Schema & Business Queries
To enable lightning-fast querying and structured analytical storage, the cleaned flat data was normalized into a dimensional *Star Schema* within Microsoft SQL Server.
* *Dimensional Modeling (Star Schema):* Designed a high-performance relational structure consisting of a centralized Fact table linked to decoupled Dimension tables via strict Primary Key/Foreign Key boundaries:
  * *Fact_Order:* Holds operational transaction records,OrderID,CustomerID,Product_ID.
  * *Dim_Product:* Stores static product properties such as Product name, product_id, Rating, Price_cleaned.
  * *Analytical Queries:* Total Revenue, top 5 selling product, customer spending behavior, Rating wise best performing product,customer segmentation and so on.
    
### 🔹 Step 3: Power BI – Executive Insights & Visual Interface
The analytical schema was connected directly to Power BI to render a sleek, corporate-grade dashboard optimized for visual data storytelling.
* *Data Modeling:* Loaded the star-schema design directly, configuring relational multi-cardinalities (1-to-many relationships) cleanly between dimensional layers.
* *DAX Engineering:* Programmed high-value Data Analysis Expressions (DAX) metrics to accurately track business health indicators (including Total Revenue, Orders, Average Basket Size, and Quality Metric Indexes).
* *UI/UX Optimization:* Converted statistical outputs into structured visuals using dynamic Gauge charts, structured horizontal bar charts, clean categorical filters, funnel and donut chart designed for stakeholder review.
* [Dashboard Lyout Preview](dashboard_preview.jpg)

---

## 📊 Dashboard Key Features
* *Executive Summary KPIs:* Immediate visibility into corporate health metrics: *Total Orders (1K), **Total Revenue ($70.38K), Average **Quality Metric (2.92), and Average **Basket Size (1.99)*.
* *Customer Distribution Metrics:* Tracks behavioral engagement parameters to identify key buyer clusters.
* *Top-Performing Product Contribution:* Horizontal distribution charts tracking specific product catalogs filtered by revenue and transaction frequencies.
* *Granular Interactive Slicers:* Instant, canvas-wide cross-filtering enabled for Product_Name, Customer Segmentation, a…
