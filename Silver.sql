 -- =====Silver.Customers====

SELECT
    TRY_CAST(customer_id AS INT)                AS customer_id,
    LTRIM(RTRIM(cc_num))                        AS cc_num,
    LTRIM(RTRIM(first_name))                    AS first_name,
    LTRIM(RTRIM(last_name))                     AS last_name,
    UPPER(LTRIM(RTRIM(gender)))                 AS gender,
    ISNULL(LTRIM(RTRIM(street)), '')            AS street,
    ISNULL(LTRIM(RTRIM(city)), '')              AS city,
    ISNULL(LTRIM(RTRIM(state)), '')             AS state,
    ISNULL(LTRIM(RTRIM(zip)), '')               AS zip,
    TRY_CAST(lat AS DECIMAL(9,4))               AS lat,
    TRY_CAST([long] AS DECIMAL(9,4))            AS [long],
    TRY_CAST(city_pop AS INT)                   AS city_pop,
    LTRIM(RTRIM(job))                           AS job,
    TRY_CAST(dob AS DATE)                       AS dob,
    CASE
        WHEN NULLIF(LTRIM(RTRIM(loyalty_tier)), '') IS NULL THEN 'None'
        ELSE LTRIM(RTRIM(loyalty_tier))
    END                                         AS loyalty_tier,
    LOWER(LTRIM(RTRIM(email_domain)))           AS email_domain,
    CASE
        WHEN TRY_CAST(signup_date AS DATE) < TRY_CAST(dob AS DATE) THEN NULL
        ELSE TRY_CAST(signup_date AS DATE)
    END                                         AS signup_date
INTO Silver.customers
FROM Broze.customers;

ALTER TABLE Silver.customers ALTER COLUMN customer_id INT NOT NULL;
ALTER TABLE Silver.customers ADD CONSTRAINT PK_Silver_customers PRIMARY KEY (customer_id);


-- ========== Silver.merchants ==========
--  * 400 rows, no duplicates, no conversion failures
DROP TABLE IF EXISTS Silver.merchants;
GO

SELECT
    TRY_CAST(merchant_id AS INT)              AS merchant_id,
    LTRIM(RTRIM(merchant_name))               AS merchant_name,
    LTRIM(RTRIM(dominant_category))           AS dominant_category,
    ISNULL(LTRIM(RTRIM(merchant_city)), '')   AS merchant_city,
    UPPER(ISNULL(LTRIM(RTRIM(merchant_state)), '')) AS merchant_state,
    TRY_CAST(merchant_lat AS DECIMAL(9,4))    AS merchant_lat,
    TRY_CAST(merchant_long AS DECIMAL(9,4))   AS merchant_long,
    TRY_CAST(merchant_since AS DATE)          AS merchant_since,
    CASE
        WHEN UPPER(LTRIM(RTRIM(is_active))) IN ('1','TRUE','YES','Y') THEN 1
        ELSE 0
    END                                       AS is_active
INTO Silver.merchants
FROM Bronze.Merchants;

ALTER TABLE Silver.merchants ALTER COLUMN merchant_id INT NOT NULL;
ALTER TABLE Silver.merchants ADD CONSTRAINT PK_Silver_merchants PRIMARY KEY (merchant_id);


-- ========== Silver.transactions ==========
--  * 50000 rows, no nulls, no duplicates, no conversion failures
DROP TABLE IF EXISTS Silver.transactions;
GO

SELECT
    TRY_CAST(transaction_id AS BIGINT)            AS transaction_id,
    TRY_CAST(trans_date_trans_time AS DATETIME2)  AS trans_datetime,
    CAST(TRY_CAST(trans_date_trans_time AS DATETIME2) AS DATE) AS trans_date,
    TRY_CAST(customer_id AS INT)                  AS customer_id,
    TRY_CAST(merchant_id AS INT)                  AS merchant_id,
    LTRIM(RTRIM(category))                        AS category,
    TRY_CAST(amt AS DECIMAL(12,2))                AS amt,
    TRY_CAST(tax_amt AS DECIMAL(12,2))            AS tax_amt,
    TRY_CAST(discount_amt AS DECIMAL(12,2))       AS discount_amt,
    UPPER(LTRIM(RTRIM(currency)))                 AS currency,
    LTRIM(RTRIM(payment_method))                  AS payment_method,
    LTRIM(RTRIM(channel))                         AS channel,
    LTRIM(RTRIM(entry_mode))                      AS entry_mode,
    LTRIM(RTRIM(device_type))                     AS device_type,
    LTRIM(RTRIM(transaction_status))              AS transaction_status,
    LTRIM(RTRIM(trans_num))                       AS trans_num,
    LTRIM(RTRIM(session_id))                      AS session_id,
    TRY_CAST(unix_time AS BIGINT)                 AS unix_time,
    TRY_CAST(is_fraud AS BIT)                     AS is_fraud
INTO Silver.transactions
FROM Bronze.transactions;
GO

ALTER TABLE Silver.transactions ALTER COLUMN transaction_id BIGINT NOT NULL;
ALTER TABLE Silver.transactions ADD CONSTRAINT PK_Silver_transactions PRIMARY KEY (transaction_id);
GO

