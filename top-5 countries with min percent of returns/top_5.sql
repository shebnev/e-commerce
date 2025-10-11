USE e_commerce;

-- выделить топ-5 стран по кол-ву уникальных заказов за весь период;
WITH top_5 AS (
	SELECT 
		s.Country,
        COUNT(DISTINCT(s.InvoiceNo)) AS order_count, 
        t.total_orders_sum, 
        m.total_return_sum
	FROM sales2 s
    
    -- подзапрос: расчет общей суммы заказов;
	LEFT JOIN (
		SELECT 
			Country, 
            ROUND(SUM(Quantity * UnitPrice), 0) AS total_orders_sum
		FROM sales2
		WHERE Quantity > 0
		GROUP BY Country
	) t
	ON s.Country = t.Country
	
    -- подзапрос: расчет общей суммы возвратов;
    LEFT JOIN (
		SELECT 
			Country, 
            ROUND(SUM(-(Quantity) * UnitPrice), 0) AS total_return_sum
		FROM sales2
		WHERE Quantity < 0
		GROUP BY Country
	) m
	ON s.Country = m.Country
	GROUP BY s.Country, t.total_orders_sum, m.total_return_sum
    ORDER BY order_count DESC
    LIMIT 5
)

/* основной запрос: 
- выделение основной информации из CTE;
- расчет выручки за весь период по странам;
- определение кол-ва процентов от суммы возвратов относительно суммы покупок;
- вывод основной информации в порядке увелечения процентов возвратов по странам.
*/

SELECT
	RANK() OVER (ORDER BY total_return_sum / total_orders_sum) AS position,
	Country, 
	order_count,
    total_orders_sum,
    total_return_sum,
    total_orders_sum - total_return_sum AS proceeds,
    ROUND(total_return_sum / total_orders_sum * 100, 1) AS percentage_returns
FROM top_5;