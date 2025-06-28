-- Crear tabla de producto de datos: Evolución mensual de pedidos

DROP TABLE IF EXISTS DP04_EvolucionMensualPedidos;

CREATE TABLE DP04_EvolucionMensualPedidos AS
SELECT
  T.year,
  T.month,
  T.month_name,
  COUNT(O.orderID) AS cantidad_pedidos
FROM DWH_Fact_Orders O
JOIN DWH_Dim_Time T ON DATE(O.orderDate) = DATE(T.date)
GROUP BY T.year, T.month, T.month_name
ORDER BY T.year, T.month;
