USE BankRetail;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Gold')
    EXEC('CREATE SCHEMA Gold');
GO

DROP TABLE IF EXISTS Gold.FactTransaction;
DROP TABLE IF EXISTS Gold.DimDate;
DROP TABLE IF EXISTS Gold.DimCustomer;
DROP TABLE IF EXISTS Gold.DimMerchant;
GO

-- ========== DimDate ==========
CREATE TABLE Gold.DimDate (
    date_key   INT         NOT NULL PRIMARY KEY,
    full_date  DATE        NOT NULL,
    [year]     INT         NOT NULL,
    [quarter]  INT         NOT NULL,
    [month]    INT         NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    [day]      INT         NOT NULL,
    day_name   VARCHAR(20) NOT NULL,
    is_weekend BIT         NOT NULL
);
GO

DECLARE @start_date DATE, @end_date DATE, @current_date DATE;

SELECT
    @start_date = MIN(trans_date),
    @end_date   = MAX(trans_date)
FROM Silver.transactions;

SET @current_date = @start_date;

WHILE @current_date <= @end_date
BEGIN
    INSERT INTO Gold.DimDate
    VALUES (
        CAST(FORMAT(@current_date, 'yyyyMMdd') AS INT),
        @current_date,
        YEAR(@current_date),
        DATEPART(QUARTER, @current_date),
        MONTH(@current_date),
        DATENAME(MONTH, @current_date),
        DAY(@current_date),
        DATENAME(WEEKDAY, @current_date),
        CASE WHEN DATENAME(WEEKDAY, @current_date) IN ('Saturday','Sunday') THEN 1 ELSE 0 END
    );
    SET @current_date = DATEADD(DAY, 1, @current_date);
END;
GO

-- ========== DimCustomer ==========
SELECT *
INTO Gold.DimCustomer
FROM Silver.customers;
GO

ALTER TABLE Gold.DimCustomer ADD CONSTRAINT PK_DimCustomer PRIMARY KEY (customer_id);
GO

-- ========== DimMerchant ==========
SELECT *
INTO Gold.DimMerchant
FROM Silver.merchants;
GO

ALTER TABLE Gold.DimMerchant ADD CONSTRAINT PK_DimMerchant PRIMARY KEY (merchant_id);
GO

-- ========== FactTransaction ==========
SELECT
    transaction_id,
    CAST(FORMAT(trans_date, 'yyyyMMdd') AS INT) AS date_key,
    trans_datetime,
    customer_id,
    merchant_id,
    category,
    amt,
    tax_amt,
    discount_amt,
    currency,
    payment_method,
    channel,
    entry_mode,
    device_type,
    transaction_status,
    trans_num,
    session_id,
    unix_time,
    is_fraud
INTO Gold.FactTransaction
FROM Silver.transactions;
GO

ALTER TABLE Gold.FactTransaction ADD CONSTRAINT PK_FactTransaction PRIMARY KEY (transaction_id);
GO

-- ========== Foreign Keys ==========
ALTER TABLE Gold.FactTransaction
    ADD CONSTRAINT FK_Fact_DimDate     FOREIGN KEY (date_key)    REFERENCES Gold.DimDate (date_key);
ALTER TABLE Gold.FactTransaction
    ADD CONSTRAINT FK_Fact_DimCustomer FOREIGN KEY (customer_id) REFERENCES Gold.DimCustomer (customer_id);
ALTER TABLE Gold.FactTransaction
    ADD CONSTRAINT FK_Fact_DimMerchant FOREIGN KEY (merchant_id) REFERENCES Gold.DimMerchant (merchant_id);
GO

-- ========== Indexes ==========
CREATE INDEX IX_Fact_DateKey     ON Gold.FactTransaction (date_key);
CREATE INDEX IX_Fact_CustomerId  ON Gold.FactTransaction (customer_id);
CREATE INDEX IX_Fact_MerchantId  ON Gold.FactTransaction (merchant_id);
GO

--       =======test=========
SELECT COUNT(*) FROM Gold.FactTransaction;   -- 50000
SELECT COUNT(*) FROM Gold.DimCustomer;       -- نفس Silver.customers
SELECT COUNT(*) FROM Gold.DimMerchant;       -- 400
SELECT MIN(full_date), MAX(full_date), COUNT(*) FROM Gold.DimDate;

-- اختبار join: لازم يرجع صفوف
SELECT TOP 10
    d.full_date, c.first_name, m.merchant_name, f.amt, f.is_fraud
FROM Gold.FactTransaction f
JOIN Gold.DimDate     d ON f.date_key    = d.date_key
JOIN Gold.DimCustomer c ON f.customer_id = c.customer_id
JOIN Gold.DimMerchant m ON f.merchant_id = m.merchant_id;