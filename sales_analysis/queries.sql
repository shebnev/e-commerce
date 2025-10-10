USE e_commerce;

-- рассчитываем выручку по товарам с ключевым словом "POPPY" за 2010 г.
WITH sales_2010 AS (
	SELECT 
		StockCode, 
		Description,
		YEAR(InvoiceDate) AS year,
		COALESCE(ROUND(SUM(Quantity * UnitPrice), 0), 0) AS total_sales
	FROM sales2
	WHERE Description LIKE '%POPPY%' AND YEAR(InvoiceDate) = 2010
	GROUP BY StockCode, Description, YEAR(InvoiceDate)
),

-- рассчитываем выручку по товарам с ключевым словом "POPPY" за 2011 г.
sales_2011 AS (
	SELECT 
		StockCode,
        Description,
        YEAR(InvoiceDate) AS year,
        ROUND(SUM(Quantity * UnitPrice), 0) AS total_sales
	FROM sales2
    WHERE Description LIKE '%POPPY%' AND YEAR(InvoiceDate) = 2011
    GROUP BY StockCode, Description, YEAR(InvoiceDate)
),

-- рассчитываем общую выручку и её разницу за 2011 и 2010 гг.
final AS (
	SELECT 
		s1.StockCode,
		s1.Description,
		COALESCE(s1.total_sales, 0) AS total_2011,
		COALESCE(s0.total_sales, 0) AS total_2010,
		COALESCE(s1.total_sales - s0.total_sales, s1.total_sales) AS difference_total
	FROM sales_2011 AS s1
	LEFT JOIN sales_2010 AS s0
	ON s1.StockCode = s0.StockCode
)

-- добавляем процентное соотношение выручки за 2011 г. относительно выручки за 2010 г.
SELECT 
	f.StockCode,
    f.Description,
    f.total_2011,
    f.total_2010,
    f.difference_total,
    perc.difference_percantage
FROM final AS f
LEFT JOIN (SELECT
	f2.StockCode,
	CONCAT(ROUND((f2.total_2011 - f2.total_2010) / f2.total_2011 * 100, 1), '%') AS difference_percantage
    FROM final AS f2) AS perc
ON f.StockCode = perc.StockCode
ORDER BY perc.difference_percantage
LIMIT 3;