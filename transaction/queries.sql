BEGIN;

CREATE TEMPORARY TABLE backups AS
SELECT *
FROM sales2
WHERE Quantity < 0
AND InvoiceDate >= DATE_FORMAT(current_date(), '%Y-%m-01');

UPDATE sales2
SET UnitPrice = ABS(UnitPrice)
WHERE Quantity < 0 
AND InvoiceDate >= DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01');

SELECT ROW_COUNT() AS updated_rows;

-- если все в порядке, COMMIT;

-- если что-то сломалось, ROLLBACK;