USE e_commerce;

-- рассчитываем продажи стран по месяцам за весь период;
WITH month_sales AS (
	SELECT 
		Country,
        DATE_FORMAT(InvoiceDate, '%Y-%m') AS date,
        ROUND(SUM(Quantity * UnitPrice), 1) AS amount
	FROM sales2
    WHERE Quantity > 0
    GROUP BY Country, DATE_FORMAT(InvoiceDate, '%Y-%m') 
),

-- получаем стандартное отклонение продаж по странам;
std_sales AS (
	SELECT 
		Country,
		ROUND(STDDEV_SAMP(amount), 1) AS std_monthly_sales
    FROM month_sales
    GROUP BY Country
)

/** итоговый запрос:
- получаем страну, средние ежемесячные продажи, среднее отклонение
  и процентное соотношение продаж и отклонения продаж;
- настраиваем порядок результатов и ограничиваем результирующий запрос
  5 строками
**/
SELECT 
	s.Country,
    ROUND(AVG(m.amount), 1) AS avg_sales,
    s.std_monthly_sales,
    ROUND(s.std_monthly_sales / AVG(m.amount) * 100, 1) AS cv_percent
FROM std_sales AS s
INNER JOIN month_sales AS m
ON s.Country = m.Country
WHERE s.std_monthly_sales IS NOT NULL
GROUP BY s.Country
ORDER BY cv_percent DESC
LIMIT 5;