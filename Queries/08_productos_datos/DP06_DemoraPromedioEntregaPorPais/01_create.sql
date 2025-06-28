-- Crear tabla de producto de datos: Demora promedio de entrega por país

DROP TABLE IF EXISTS DP06_DemoraPromedioEntregaPorPais;

CREATE TABLE DP06_DemoraPromedioEntregaPorPais AS
SELECT
  C.country,
  ROUND(AVG(JULIANDAY(O.shippedDate) - JULIANDAY(O.orderDate)), 2) AS demora_promedio_dias
FROM DWH_Fact_Orders O
JOIN DWH_Dim_Customers C ON O.customerID = C.customerID
WHERE O.shippedDate IS NOT NULL AND O.orderDate IS NOT NULL
GROUP BY C.country
ORDER BY demora_promedio_dias DESC;
