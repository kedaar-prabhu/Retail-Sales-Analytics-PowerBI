use retail_sales_db;

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'D:/Downloads/store-sales-time-series-forecasting/train.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM holidays_events;

SELECT 
    s.store_nbr,
    st.city,
    st.type,
    ROUND(SUM(s.sales), 2) AS total_revenue
FROM sales s
JOIN stores st ON s.store_nbr = st.store_nbr
GROUP BY s.store_nbr, st.city, st.type
ORDER BY total_revenue DESC
LIMIT 10;

SELECT 
    family,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(AVG(sales), 2) AS avg_daily_sales
FROM sales
GROUP BY family
ORDER BY total_sales DESC
LIMIT 5;

SELECT 
    CASE WHEN onpromotion > 0 THEN 'On Promotion' ELSE 'No Promotion' END AS promo_status,
    ROUND(AVG(sales), 2) AS avg_sales,
    COUNT(*) AS total_records
FROM sales
GROUP BY promo_status;

SELECT 
    MONTH(date) AS month_number,
    MONTHNAME(date) AS month_name,
    ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY month_number, month_name
ORDER BY total_sales DESC;

SELECT 
    store_nbr,
    city,
    total_revenue,
    RANK() OVER (PARTITION BY city ORDER BY total_revenue DESC) AS city_rank
FROM (
    SELECT 
        s.store_nbr,
        st.city,
        ROUND(SUM(s.sales), 2) AS total_revenue
    FROM sales s
    JOIN stores st ON s.store_nbr = st.store_nbr
    GROUP BY s.store_nbr, st.city
) AS store_totals
ORDER BY city, city_rank;

SELECT 
    date,
    ROUND(SUM(sales), 2) AS daily_sales,
    ROUND(AVG(SUM(sales)) OVER (
        ORDER BY date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_7day_avg
FROM sales
GROUP BY date
ORDER BY date;

SELECT 
    CASE WHEN h.date IS NOT NULL THEN 'Holiday' ELSE 'Non-Holiday' END AS day_type,
    ROUND(AVG(s.sales), 2) AS avg_sales,
    ROUND(SUM(s.sales), 2) AS total_sales,
    COUNT(*) AS total_records
FROM sales s
LEFT JOIN holidays_events h ON s.date = h.date
GROUP BY day_type;

SELECT 
    store_nbr,
    year,
    total_sales,
    LAG(total_sales) OVER (PARTITION BY store_nbr ORDER BY year) AS prev_year_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (PARTITION BY store_nbr ORDER BY year)) 
        / LAG(total_sales) OVER (PARTITION BY store_nbr ORDER BY year) * 100
    , 2) AS yoy_growth_pct
FROM (
    SELECT 
        store_nbr,
        YEAR(date) AS year,
        ROUND(SUM(sales), 2) AS total_sales
    FROM sales
    GROUP BY store_nbr, year
) AS yearly_sales
ORDER BY store_nbr, year;

WITH ranked_products AS (
    SELECT 
        store_nbr,
        family,
        ROUND(SUM(sales), 2) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY store_nbr ORDER BY SUM(sales) DESC) AS rn
    FROM sales
    GROUP BY store_nbr, family
)
SELECT 
    store_nbr,
    family AS top_product,
    total_sales
FROM ranked_products
WHERE rn = 1
ORDER BY store_nbr;

WITH store_avg AS (
    SELECT 
        store_nbr,
        ROUND(AVG(transactions), 2) AS avg_transactions
    FROM transactions
    GROUP BY store_nbr
),
overall_avg AS (
    SELECT ROUND(AVG(transactions), 2) AS overall_avg FROM transactions
)
SELECT 
    sa.store_nbr,
    st.city,
    st.type,
    sa.avg_transactions,
    oa.overall_avg,
    CASE 
        WHEN sa.avg_transactions > oa.overall_avg THEN 'Above Average'
        ELSE 'Below Average'
    END AS performance
FROM store_avg sa
JOIN stores st ON sa.store_nbr = st.store_nbr
CROSS JOIN overall_avg oa
ORDER BY sa.avg_transactions DESC;
