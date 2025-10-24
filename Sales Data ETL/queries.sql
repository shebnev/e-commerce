CREATE DATABASE IF NOT EXISTS Sales_Dataset;
USE Sales_Dataset;

-- Таблица с временными типами данных для быстрой загрузки CSV-файла
CREATE TABLE IF NOT EXISTS orders (
	order_id VARCHAR(30) NOT NULL,
    amount VARCHAR(50) NOT NULL,
    profit VARCHAR(50),
    quantity VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(100),
    payment_mode VARCHAR(50),
    order_date VARCHAR(50),
    customer_name VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(50),
    y_month VARCHAR(50)
);

-- Разрешение серверу загружать локальные файлы с компьютера
SET GLOBAL local_infile = 1;

-- Перенос данных с CSV-файла в таблицу orders
LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Downloads/Sales Dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
-- присвоение переменных, т. к. заголовки исходного файла совпадают с ключевыми словами
(@order_id, @amount, @profit, @quantity, @category, @sub_category, @payment_mode, @order_date, @customer_name, @state, @city, @y_month)
SET
order_id = @order_id,
amount = @amount,
profit = @profit,
quantity = @quantity,
category = @category,
sub_category = @sub_category,
payment_mode = @payment_mode,
order_date = (@order_date),
customer_name = @customer_name,
state = @state,
city = @city,
y_month = @y_month;


-- Установить режим обнавления таблицы без условий 'WHERE'
SET SQL_SAFE_UPDATES = 0;

-- обновить столбец amount в тип данных INT
UPDATE orders 
SET amount = CAST(NULLIF(amount, '') AS SIGNED);

ALTER TABLE orders
MODIFY amount INT;

-- обновить столбец profit в тип данных INT
UPDATE orders
SET profit = CAST(NULLIF(profit, '') AS SIGNED);

ALTER TABLE orders
MODIFY profit INT;

-- обновить столбец quantity в тип данных INT
UPDATE orders 
SET quantity = CAST(NULLIF(quantity, '') AS SIGNED);

ALTER TABLE orders
MODIFY quantity INT;

-- обновить столбец order_date в тип данных DATE
UPDATE orders
SET order_date = STR_TO_DATE(NULLIF(order_date, ''), '%Y-%m-%d');

ALTER TABLE orders
MODIFY order_date DATE;

SET SQL_SAFE_UPDATES = 1;