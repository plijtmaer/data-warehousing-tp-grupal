SELECT 
  STRFTIME('%Y-%m', O.orderDate) AS mes,
  C.country,
  ROUND(SUM(OD.totalPrice), 2) AS total_ingresos
FROM DWH_Fact_Orders O
JOIN DWH_Fact_OrderDetails OD ON O.orderID = OD.orderID
JOIN DWH_Dim_Customers C ON O.customerID = C.customerID
GROUP BY mes, C.country
ORDER BY mes, total_ingresos DESC;
