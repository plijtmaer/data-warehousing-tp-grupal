-- Crear tabla de producto de datos: Ventas por categoría y país

DROP TABLE IF EXISTS DP01_VentasPorCategoriaYPais;

CREATE TABLE DP01_VentasPorCategoriaYPais AS
SELECT
    C.country,
    CAT.categoryName,
    ROUND(SUM(OD.unitPrice * OD.quantity), 2) AS total_ventas,
    SUM(OD.quantity) AS cantidad_productos
FROM DWH_Fact_OrderDetails OD
JOIN DWH_Fact_Orders O ON OD.orderID = O.orderID
JOIN DWH_Dim_Customers C ON O.customerID = C.customerID
JOIN DWH_Dim_Products P ON OD.productID = P.productID
JOIN DWH_Dim_Categories CAT ON P.categoryID = CAT.categoryID
GROUP BY C.country, CAT.categoryName
HAVING total_ventas > 0;
