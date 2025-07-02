DROP VIEW IF EXISTS VW_OrderTime;

CREATE VIEW VW_OrderTime AS
SELECT
  o.orderID,
  t.date,
  t.year,
  t.month,
  t.month_name,
  t.quarter,
  t.day,
  t.weekday,
  t.weekday_name,
  t.is_weekend
FROM DWH_Fact_Orders o
JOIN DWH_Dim_Time t ON substr(o.orderDate, 1, 10) = t.date;
