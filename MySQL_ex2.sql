/* 프로젝트: 데이터 기반 인사이트 추출을 위한 주문 데이터 분석 */

/*SQL SKILLS: joins, date manipulation, aggregate functions, data transformation, string manipulation*/

-- --------------------------------------------------------------------------------------------------------------
/*Ques.1 : 지역별로 가장 높은 매출을 기록한 지역은 어디인가?*/

SELECT 
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Discount) AS Average_Discount
FROM
    orders
GROUP BY Region
ORDER BY Total_Sales DESC
LIMIT 1;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.2 : 가장 높은 이익을 낸 상위 5개의 제품은 무엇인가?*/

SELECT 
    `Product Name`,
    SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY `Product Name`
ORDER BY Total_Profit DESC
LIMIT 5;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.3 : 환불된 주문의 비율이 가장 높은 지역은 어디인가?*/

SELECT 
    Region,
    SUM(CASE WHEN r.`Order ID` IS NOT NULL THEN 1 ELSE 0 END) AS Returned_Orders,
    COUNT(o.`Order ID`) AS Total_Orders,
    ROUND(SUM(CASE WHEN r.`Order ID` IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(o.`Order ID`), 2) AS Return_Percentage
FROM
    orders o
        LEFT JOIN
    returns r ON o.`Order ID` = r.`Order ID`
GROUP BY Region
ORDER BY Return_Percentage DESC
LIMIT 1;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.4 : 배송 시간이 가장 빠른 배송 모드는 무엇인가?*/

SELECT 
    `Ship Mode`,
    AVG(TIMESTAMPDIFF(DAY, `Order Date`, `Ship Date`)) AS Avg_Shipping_Days,
    AVG(TIMESTAMPDIFF(HOUR, `Order Date`, `Ship Date`)) AS Avg_Shipping_Hours
FROM
    orders
GROUP BY `Ship Mode`
ORDER BY Avg_Shipping_Days ASC
LIMIT 1;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.5 : 가장 많은 주문을 처리한 고객은 누구인가?*/

SELECT 
    `Customer ID`,
    `Customer Name`,
    COUNT(`Order ID`) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Total_Orders DESC
LIMIT 1;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.6 : 월별 매출 및 이익 트렌드는 어떻게 변화하고 있는가?*/

SELECT 
    DATE_FORMAT(`Order Date`, '%Y-%m') AS Order_Month,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM
    orders
GROUP BY Order_Month
ORDER BY Order_Month;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.7 : 카테고리별 이익률이 가장 높은 세부 카테고리는 무엇인가?*/

SELECT 
    Category,
    `Sub-Category`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Discount) AS Average_Discount
FROM
    orders
GROUP BY Category, `Sub-Category`
ORDER BY Total_Profit DESC
LIMIT 1;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.8 : 평균 배송 시간은 몇 일인가?*/

SELECT 
    ROUND(AVG(TIMESTAMPDIFF(DAY, `Order Date`, `Ship Date`)), 2) AS Avg_Shipping_Time_Days
FROM
    orders;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.9 : 연도별 총 주문 수는 어떻게 변화했는가?*/

SELECT 
    YEAR(`Order Date`) AS Order_Year,
    COUNT(`Order ID`) AS Total_Orders
FROM
    orders
GROUP BY Order_Year
ORDER BY Order_Year;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.10 : 특정 고객의 주문 내역과 평균 할인율은 무엇인가?*/

CREATE PROCEDURE `spCustomerOrderDetails`(IN customerId VARCHAR(255))
BEGIN
    SELECT 
        o.`Order ID`,
        o.`Order Date`,
        o.Sales,
        o.Profit,
        o.Discount
    FROM
        orders o
    WHERE
        o.`Customer ID` = customerId;

    SELECT 
        ROUND(AVG(o.Discount), 2) AS Avg_Discount
    FROM
        orders o
    WHERE
        o.`Customer ID` = customerId;
END //

CALL `spCustomerOrderDetails`('C001');
-- --------------------------------------------------------------------------------------------------------------

/*Ques.11 : 전체 데이터에서 배송 시간과 주문 날짜 간의 관계 요약*/

SELECT 
    DATE_FORMAT(`Order Date`, '%Y-%m') AS Order_Month,
    AVG(TIMESTAMPDIFF(DAY, `Order Date`, `Ship Date`)) AS Avg_Shipping_Days
FROM
    orders
GROUP BY Order_Month
ORDER BY Order_Month;
-- --------------------------------------------------------------------------------------------------------------
