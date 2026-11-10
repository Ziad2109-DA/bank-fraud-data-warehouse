
use BankRetail;
go


-- 1. 
SELECT COUNT(*) AS total_rows FROM Broze.customers;

-- 2. ===Nulls / Blanks=====
SELECT
    SUM(CASE WHEN customer_id  IS NULL OR customer_id  = '' THEN 1 ELSE 0 END) AS blank_customer_id,
    SUM(CASE WHEN cc_num       IS NULL OR cc_num       = '' THEN 1 ELSE 0 END) AS blank_cc_num,
    SUM(CASE WHEN first_name   IS NULL OR first_name   = '' THEN 1 ELSE 0 END) AS blank_first_name,
    SUM(CASE WHEN last_name    IS NULL OR last_name    = '' THEN 1 ELSE 0 END) AS blank_last_name,
    SUM(CASE WHEN gender       IS NULL OR gender       = '' THEN 1 ELSE 0 END) AS blank_gender,
    SUM(CASE WHEN city         IS NULL OR city         = '' THEN 1 ELSE 0 END) AS blank_city,
    SUM(CASE WHEN [state]        IS NULL OR [state]        = '' THEN 1 ELSE 0 END) AS blank_state,
    SUM(CASE WHEN zip          IS NULL OR zip          = '' THEN 1 ELSE 0 END) AS blank_zip,
    SUM(CASE WHEN dob          IS NULL OR dob          = '' THEN 1 ELSE 0 END) AS blank_dob,
    SUM(CASE WHEN loyalty_tier IS NULL OR loyalty_tier = '' THEN 1 ELSE 0 END) AS blank_loyalty_tier,
    SUM(CASE WHEN email_domain IS NULL OR email_domain = '' THEN 1 ELSE 0 END) AS blank_email_domain,
    SUM(CASE WHEN signup_date  IS NULL OR signup_date  = '' THEN 1 ELSE 0 END) AS blank_signup_date
FROM Broze.customers;

-- 3. 
SELECT * FROM Broze.customers WHERE TRY_CAST(customer_id  AS INT)           IS NULL;
SELECT * FROM Broze.customers WHERE TRY_CAST(zip          AS INT)           IS NULL;
SELECT * FROM Broze.customers WHERE TRY_CAST(lat          AS DECIMAL(9,4))  IS NULL;
SELECT * FROM Broze.customers WHERE TRY_CAST([long]       AS DECIMAL(9,4))  IS NULL;
SELECT * FROM Broze.customers WHERE TRY_CAST(city_pop     AS INT)           IS NULL;
SELECT * FROM Broze.customers WHERE TRY_CAST(dob          AS DATE)          IS NULL;
SELECT * FROM Broze.customers WHERE TRY_CAST(signup_date  AS DATE)          IS NULL;

 -- categories 
SELECT gender,       COUNT(*) AS cnt FROM Broze.customers GROUP BY gender;
SELECT loyalty_tier, COUNT(*) AS cnt FROM Broze.customers GROUP BY loyalty_tier;
SELECT email_domain, COUNT(*) AS cnt FROM Broze.customers GROUP BY email_domain ORDER BY cnt DESC;

-- 5.Duplicates
SELECT customer_id, COUNT(*) AS cnt
FROM Broze.customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT cc_num, COUNT(*) AS cnt
FROM Broze.customers
GROUP BY cc_num
HAVING COUNT(*) > 1;

-- 6. 
SELECT * FROM Broze.customers
WHERE TRY_CAST(dob AS DATE) > GETDATE()
   OR TRY_CAST(dob AS DATE) < '1900-01-01';

SELECT * FROM Broze.customers
WHERE TRY_CAST(signup_date AS DATE) > GETDATE();

SELECT * FROM Broze.customers
WHERE TRY_CAST(signup_date AS DATE) < TRY_CAST(dob AS DATE);


-- ==================== merchants======================

SELECT COUNT(*) AS total_rows FROM Bronze.Merchants;

-- Nulls / Blanks
SELECT
    SUM(CASE WHEN merchant_id        IS NULL OR merchant_id        = '' THEN 1 ELSE 0 END) AS blank_merchant_id,
    SUM(CASE WHEN merchant_name      IS NULL OR merchant_name      = '' THEN 1 ELSE 0 END) AS blank_name,
    SUM(CASE WHEN dominant_category  IS NULL OR dominant_category  = '' THEN 1 ELSE 0 END) AS blank_category,
    SUM(CASE WHEN merchant_city      IS NULL OR merchant_city      = '' THEN 1 ELSE 0 END) AS blank_city,
    SUM(CASE WHEN merchant_state     IS NULL OR merchant_state     = '' THEN 1 ELSE 0 END) AS blank_state,
    SUM(CASE WHEN merchant_since     IS NULL OR merchant_since     = '' THEN 1 ELSE 0 END) AS blank_since,
    SUM(CASE WHEN is_active          IS NULL OR is_active          = '' THEN 1 ELSE 0 END) AS blank_is_active
FROM Bronze.Merchants;

-- Conversion failures
SELECT * FROM Bronze.Merchants WHERE TRY_CAST(merchant_id   AS INT)          IS NULL;
SELECT * FROM Bronze.Merchants WHERE TRY_CAST(merchant_lat  AS DECIMAL(9,4)) IS NULL;
SELECT * FROM Bronze.Merchants WHERE TRY_CAST(merchant_long AS DECIMAL(9,4)) IS NULL;
SELECT * FROM Bronze.Merchants WHERE TRY_CAST(merchant_since AS DATE)        IS NULL;

-- Categories
SELECT dominant_category, COUNT(*) AS cnt FROM Bronze.Merchants GROUP BY dominant_category;
SELECT is_active,         COUNT(*) AS cnt FROM Bronze.Merchants GROUP BY is_active;
SELECT merchant_state,    COUNT(*) AS cnt FROM Bronze.Merchants GROUP BY merchant_state ORDER BY cnt DESC;

-- Duplicates
SELECT merchant_id, COUNT(*) AS cnt
FROM Bronze.Merchants
GROUP BY merchant_id HAVING COUNT(*) > 1;

-- Logic
SELECT * FROM Bronze.Merchants WHERE TRY_CAST(merchant_since AS DATE) > GETDATE();

---=====Transactions======

SELECT COUNT(*) AS total_rows FROM Bronze.Transactions;

-- Nulls / Blanks
SELECT
    SUM(CASE WHEN transaction_id          IS NULL OR transaction_id          = '' THEN 1 ELSE 0 END) AS blank_id,
    SUM(CASE WHEN trans_date_trans_time   IS NULL OR trans_date_trans_time   = '' THEN 1 ELSE 0 END) AS blank_datetime,
    SUM(CASE WHEN customer_id             IS NULL OR customer_id             = '' THEN 1 ELSE 0 END) AS blank_customer,
    SUM(CASE WHEN merchant_id             IS NULL OR merchant_id             = '' THEN 1 ELSE 0 END) AS blank_merchant,
    SUM(CASE WHEN category                IS NULL OR category                = '' THEN 1 ELSE 0 END) AS blank_category,
    SUM(CASE WHEN amt                     IS NULL OR amt                     = '' THEN 1 ELSE 0 END) AS blank_amt,
    SUM(CASE WHEN tax_amt                 IS NULL OR tax_amt                 = '' THEN 1 ELSE 0 END) AS blank_tax,
    SUM(CASE WHEN discount_amt            IS NULL OR discount_amt            = '' THEN 1 ELSE 0 END) AS blank_discount,
    SUM(CASE WHEN currency                IS NULL OR currency                = '' THEN 1 ELSE 0 END) AS blank_currency,
    SUM(CASE WHEN payment_method          IS NULL OR payment_method          = '' THEN 1 ELSE 0 END) AS blank_payment,
    SUM(CASE WHEN channel                 IS NULL OR channel                 = '' THEN 1 ELSE 0 END) AS blank_channel,
    SUM(CASE WHEN entry_mode              IS NULL OR entry_mode              = '' THEN 1 ELSE 0 END) AS blank_entry_mode,
    SUM(CASE WHEN device_type             IS NULL OR device_type             = '' THEN 1 ELSE 0 END) AS blank_device,
    SUM(CASE WHEN transaction_status      IS NULL OR transaction_status      = '' THEN 1 ELSE 0 END) AS blank_status,
    SUM(CASE WHEN is_fraud                IS NULL OR is_fraud                = '' THEN 1 ELSE 0 END) AS blank_fraud
FROM Bronze.Transactions;

-- Conversion failures
SELECT * FROM Bronze.Transactions WHERE TRY_CAST(transaction_id        AS BIGINT)        IS NULL;
SELECT * FROM Bronze.Transactions WHERE TRY_CAST(trans_date_trans_time AS DATETIME2)     IS NULL;
SELECT * FROM Bronze.Transactions WHERE TRY_CAST(customer_id           AS INT)           IS NULL;
SELECT * FROM Bronze.Transactions WHERE TRY_CAST(merchant_id           AS INT)           IS NULL;
SELECT * FROM Bronze.Transactions WHERE TRY_CAST(amt                   AS DECIMAL(12,2)) IS NULL;
SELECT * FROM Bronze.Transactions WHERE TRY_CAST(tax_amt               AS DECIMAL(12,2)) IS NULL;
SELECT * FROM Bronze.Transactions WHERE TRY_CAST(discount_amt          AS DECIMAL(12,2)) IS NULL;
SELECT * FROM Bronze.Transactions WHERE TRY_CAST(unix_time             AS BIGINT)        IS NULL;
SELECT * FROM Bronze.Transactions WHERE TRY_CAST(is_fraud              AS INT)           IS NULL;

-- Categories
SELECT category,           COUNT(*) AS cnt FROM Bronze.Transactions GROUP BY category;
SELECT currency,           COUNT(*) AS cnt FROM Bronze.Transactions GROUP BY currency;
SELECT payment_method,     COUNT(*) AS cnt FROM Bronze.Transactions GROUP BY payment_method;
SELECT channel,            COUNT(*) AS cnt FROM Bronze.Transactions GROUP BY channel;
SELECT entry_mode,         COUNT(*) AS cnt FROM Bronze.Transactions GROUP BY entry_mode;
SELECT device_type,        COUNT(*) AS cnt FROM Bronze.Transactions GROUP BY device_type;
SELECT transaction_status, COUNT(*) AS cnt FROM Bronze.Transactions GROUP BY transaction_status;
SELECT is_fraud,           COUNT(*) AS cnt FROM Bronze.Transactions GROUP BY is_fraud;

-- Duplicates
SELECT transaction_id, COUNT(*) AS cnt
FROM Bronze.Transactions GROUP BY transaction_id HAVING COUNT(*) > 1;

SELECT trans_num, COUNT(*) AS cnt
FROM Bronze.Transactions GROUP BY trans_num HAVING COUNT(*) > 1;

-- Orphans
SELECT COUNT(*) AS orphan_customers
FROM Bronze.Transactions t
LEFT JOIN Broze.Customers c ON TRY_CAST(c.customer_id AS INT) = TRY_CAST(t.customer_id AS INT)
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS orphan_merchants
FROM Bronze.Transactions t
LEFT JOIN Bronze.merchants m ON TRY_CAST(m.merchant_id AS INT) = TRY_CAST(t.merchant_id AS INT)
WHERE m.merchant_id IS NULL;

-- Logic
SELECT * FROM Bronze.Transactions WHERE TRY_CAST(amt AS DECIMAL(12,2)) < 0;
SELECT * FROM Bronze.Transactions WHERE TRY_CAST(trans_date_trans_time AS DATETIME2) > GETDATE();