-- Crear tabla de producto de datos: Porcentaje de entregas en 5 días o menos por país

DROP TABLE IF EXISTS DP08_PorcentajeEntregasRapidasPorPais;

CREATE TABLE DP08_PorcentajeEntregasRapidasPorPais AS
SELECT
  C.country,
  ROUND(
    100.0 * SUM(CASE 
                  WHEN JULIANDAY(O.shippedDate) - JULIANDAY(O.orderDate) <= 5 
                  THEN 1 ELSE 0 END
               ) / COUNT(O.orderID), 2
  ) AS porcentaje_entregas_rapidas
FROM DWH_Fact_Orders O
JOIN DWH_Dim_Customers C ON O.customerID = C.customerID
WHERE O.shippedDate IS NOT NULL AND O.orderDate IS NOT NULL
GROUP BY C.country
ORDER BY porcentaje_entregas_rapidas DESC;
