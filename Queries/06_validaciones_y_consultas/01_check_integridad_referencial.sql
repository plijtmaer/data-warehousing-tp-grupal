-- ¿Hay algún orderID en la tabla de hechos que no exista en TMP_Orders?
SELECT orderID FROM DWH_Fact_Orders
WHERE orderID NOT IN (SELECT orderID FROM TMP_Orders);
