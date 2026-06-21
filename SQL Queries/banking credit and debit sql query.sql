USE bank_transactions_db;
-- ============================================
-- KPI 1: TOTAL CREDIT AMOUNT
-- ============================================

SELECT 
    SUM(amount) AS total_credit_amount
FROM bank_transactions
WHERE transaction_type = 'Credit';

-- ============================================
-- KPI 2: TOTAL DEBIT AMOUNT
-- ============================================

SELECT 
    SUM(amount) AS total_debit_amount
FROM bank_transactions
WHERE transaction_type = 'Debit';

-- ============================================
-- KPI 3: CREDIT TO DEBIT RATIO
-- ============================================

SELECT 
    ROUND(
        SUM(CASE WHEN transaction_type = 'Credit' THEN amount ELSE 0 END)
        /
        NULLIF(
            SUM(CASE WHEN transaction_type = 'Debit' THEN amount ELSE 0 END),
            0
        ),
    2) AS credit_debit_ratio
FROM bank_transactions;

-- ============================================
-- KPI 4: NET TRANSACTION AMOUNT
-- ============================================

SELECT
    SUM(CASE WHEN transaction_type = 'Credit' THEN amount ELSE 0 END)
    -
    SUM(CASE WHEN transaction_type = 'Debit' THEN amount ELSE 0 END)
    AS net_transaction_amount
FROM bank_transactions;

-- ============================================
-- KPI 5: ACCOUNT ACTIVITY RATIO
-- ============================================

SELECT
    account_number,
    COUNT(*) AS total_transactions,
    MAX(balance) AS current_balance,
    ROUND(
        COUNT(*) / NULLIF(MAX(balance),0),
    4) AS account_activity_ratio
FROM bank_transactions
GROUP BY account_number;

-- ============================================
-- KPI 6A: TRANSACTIONS PER DAY
-- ============================================

SELECT
    transaction_date,
    COUNT(*) AS transactions_per_day
FROM bank_transactions
GROUP BY transaction_date
ORDER BY transaction_date;

-- ============================================
-- KPI 6B: TRANSACTIONS PER WEEK
-- ============================================

SELECT
    YEAR(transaction_date) AS year,
    WEEK(transaction_date) AS week_no,
    COUNT(*) AS transactions_per_week
FROM bank_transactions
GROUP BY YEAR(transaction_date), WEEK(transaction_date)
ORDER BY year, week_no;

-- ============================================
-- KPI 6C: TRANSACTIONS PER MONTH
-- ============================================

SELECT
    YEAR(transaction_date) AS year,
    monthname(transaction_date) AS month,
    COUNT(*) AS transactions_per_month
FROM bank_transactions
GROUP BY YEAR(transaction_date), monthname(transaction_date)
ORDER BY year, month;

-- ============================================
-- KPI 7: TOTAL TRANSACTION AMOUNT BY BRANCH
-- ============================================

SELECT
    branch,
    SUM(amount) AS total_transaction_amount
FROM bank_transactions
GROUP BY branch
ORDER BY total_transaction_amount DESC;

-- ============================================
-- KPI 8: TRANSACTION VOLUME BY BANK
-- ============================================

SELECT
    bank_name,
    SUM(amount) AS transaction_volume
FROM bank_transactions
GROUP BY bank_name
ORDER BY transaction_volume DESC;

-- ============================================
-- KPI 9A: TRANSACTION METHOD DISTRIBUTION (COUNT)
-- ============================================

SELECT
    transaction_method,
    COUNT(*) AS total_transactions
FROM bank_transactions
GROUP BY transaction_method
ORDER BY total_transactions DESC;

-- ============================================
-- KPI 9B: TRANSACTION METHOD DISTRIBUTION (%)
-- ============================================

SELECT
    transaction_method,
    COUNT(*) AS transaction_count,
    ROUND(
        (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM bank_transactions),
    2) AS percentage_distribution
FROM bank_transactions
GROUP BY transaction_method
ORDER BY percentage_distribution DESC;

-- ============================================
-- KPI 10: BRANCH TRANSACTION GROWTH (MONTHLY)
-- ============================================

WITH monthly_branch_transactions AS (
    SELECT
        branch,
        YEAR(transaction_date) AS year,
        MONTH(transaction_date) AS month,
        SUM(amount) AS total_amount
    FROM bank_transactions
    GROUP BY branch, YEAR(transaction_date), MONTH(transaction_date)
)

SELECT
    branch,
    year,
    month,
    total_amount,
    LAG(total_amount) OVER (
        PARTITION BY branch
        ORDER BY year, month
    ) AS previous_month_amount,

    ROUND(
        (
            (total_amount -
            LAG(total_amount) OVER (
                PARTITION BY branch
                ORDER BY year, month
            ))
            /
            NULLIF(
                LAG(total_amount) OVER (
                    PARTITION BY branch
                    ORDER BY year, month
                ),
            0)
        ) * 100,
    2) AS growth_percentage

FROM monthly_branch_transactions;

-- ============================================
-- KPI 11: HIGH-RISK TRANSACTION FLAG
-- Example Threshold = 100000
-- ============================================

SELECT
    transaction_id,
    customer_id,
    customer_name,
    transaction_type,
    amount,
    transaction_date,
    branch,

    CASE
        WHEN amount > 4000 THEN 'High Risk'
        ELSE 'Normal'
    END AS risk_flag

FROM bank_transactions
ORDER BY amount DESC;

-- ============================================
-- KPI 12: SUSPICIOUS TRANSACTION FREQUENCY
-- ============================================

SELECT
    COUNT(*) AS suspicious_transaction_count
FROM bank_transactions
WHERE amount > 4000;

-- ============================================
-- BONUS: TOP 10 CUSTOMERS BY TRANSACTION AMOUNT
-- ============================================

SELECT
    customer_id,
    customer_name,
    SUM(amount) AS total_transaction_amount
FROM bank_transactions
GROUP BY customer_id, customer_name
ORDER BY total_transaction_amount DESC
LIMIT 10;

-- ============================================
-- BONUS: AVERAGE TRANSACTION AMOUNT
-- ============================================

SELECT
    ROUND(AVG(amount),2) AS average_transaction_amount
FROM bank_transactions;

-- ============================================
-- BONUS: DAILY NET CASH FLOW
-- ============================================

SELECT
    transaction_date,

    SUM(
        CASE
            WHEN transaction_type = 'Credit' THEN amount
            ELSE -amount
        END
    ) AS daily_net_cash_flow

FROM bank_transactions
GROUP BY transaction_date
ORDER BY transaction_date;