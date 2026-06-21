USE loan_analysis;
-- =========================================
-- 1. TOTAL LOAN AMOUNT FUNDED
-- =========================================
SELECT 
ROUND(SUM(funded_Amount_Num)) AS Total_Loan_Funded
FROM loans;
-- =========================================
-- 2. TOTAL LOANS
-- =========================================
SELECT 
COUNT(Account_ID) AS Total_Loans
FROM loans;
-- =========================================
-- 3. TOTAL COLLECTION
-- =========================================
SELECT 
ROUND(SUM(Total_Pymnt_Num),2) AS Total_Collection
FROM loans;
-- =========================================
-- 4. TOTAL INTEREST
-- =========================================
SELECT 
ROUND(SUM(CAST(Total_Rec_Int AS DECIMAL(12,2))),2) AS Total_Interest
FROM loans;
-- =========================================
-- 5. TOTAL REVENUE
-- =========================================
SELECT 
ROUND(SUM(Total_Revenue_Num),2) AS Total_Revenue
FROM loans;
-- =========================================
-- 6. BRANCH-WISE REVENUE ANALYSIS
-- =========================================
SELECT 
Branch_Name,
ROUND(SUM(CAST(Total_Rec_Int AS DECIMAL(12,2))),2) AS Interest_Income,
ROUND(SUM(CAST(Total_Fees AS DECIMAL(12,2))),2) AS Fee_Income,
ROUND(SUM(Total_Revenue_Num),2) AS Total_Revenue
from loans
group by Branch_Name
order by Total_Revenue DESC;
-- =========================================
-- 7. STATE-WISE LOAN ANALYSIS
-- =========================================
SELECT
State_Name,
count(Account_ID) as Total_Loans,
ROUND(SUM(CAST(Loan_Amount_Num AS DECIMAL(12,2))),2) AS Funded_Amount
FROM loans
group by State_Name
order by Funded_Amount DESC;
-- =========================================
-- 8. RELIGION-WISE LOAN ANALYSIS
-- =========================================
SELECT
Religion,
count(Account_ID) as Total_Loans,
ROUND(SUM(CAST(loan_Amount_Num AS DECIMAL(12,2))),2) AS Funded_Amount
FROM loans
group by Religion
order by Funded_Amount DESC;
-- =========================================
-- 9. DISBURSEMENT TREND
-- =========================================
SELECT
Disbursement_Date_Years,
count(Account_ID) as Total_Loans,
ROUND(SUM(CAST(Loan_Amount_Num AS DECIMAL(12,2))),2) AS Funded_Amount
FROM loans
group by Disbursement_Date_Years
order by Funded_Amount DESC;
-- =========================================
-- 10. LOAN STATUS ANALYSIS
-- =========================================
SELECT 
Loan_Status,
count(*) AS Loan_Count
From loans
group by Loan_Status
order by loan_count desc;
-- =========================================
-- 11.PRODUCT GROUP-WISE LOAN ANALYSIS
-- =========================================
SELECT
purpose_category as product_group,
count(*) AS loan_count,
round(sum(cast(Loan_Amount as decimal(12,1))),2) as Total_loan
from loans
group by purpose_category 
order by loan_count desc;
-- =========================================
-- 12. GRADE-WISE LOAN ANALYSIS
-- =========================================
SELECT 
Grade,
count(Account_ID) AS loan_count,
round(sum(cast(Loan_Amount as decimal(12,1))),2) as Total_loan
from loans
group by Grade
order by loan_count desc;
-- =========================================
-- 13. COUNT OF DEFAULT LOANS
-- =========================================
SELECT
count(*) as count_of_default_loans
from loans
where Is_Default_Loan = "Y";
-- =========================================
-- 14. COUNT OF DELINQUENT CLIENTS
-- =========================================
SELECT
count(*) as COUNT_OF_DELINQUENT_CLIENTS
from loans
where Is_Delinquent_Loan = "Y";
-- =========================================
-- 15. DELINQUENT LOAN RATE
-- =========================================
 SELECT 
ROUND(
(
COUNT(CASE 
WHEN Is_Delinquent_Loan = 'Y' THEN 1 
END) * 100.0
)
/ COUNT(*)
,2) AS Delinquent_Loan_Rate_Percentage
FROM loans;
-- =========================================
-- 16. DEFAULT LOAN RATE
-- =========================================
SELECT
ROUND(
(
COUNT(CASE
WHEN IS_DEFAULT_LOAN = "Y" THEN 1
END) * 100.0
)
/ COUNT(*)
,2) As Default_Loan_Rate_Percentage 
FROM LOANS;
-- =========================================
-- 17. AGE GROUP-WISE LOAN
-- =========================================
SELECT 
Age AS Age_Group,
count(*) as Loan_count,
round(sum(cast(loan_amount_num as decimal(12,2))),2) as Total_Loan
from loans
group by age
order by loan_count desc;
-- =========================================
-- 18. LOAN MATURITY ANALYSIS
-- =========================================
SELECT 
Term ,
count(*) as Loan_count,
round(sum(cast(loan_amount_num as decimal(12,2))),2) as Total_Loan
from loans
group by term
order by Total_Loan desc;
-- =========================================
-- 19. NO VERIFIED LOAN
-- =========================================
SELECT 
count(Verification_Status) as Not_verified_loans
from loans
where Verification_Status = "Not verified";
