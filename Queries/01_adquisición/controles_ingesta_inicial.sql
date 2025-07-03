-- CONTROLES SIMPLES PARA INGESTA INICIAL
-- Verificar que los datos CSV se cargaron bien en tablas temporales

-- Control 1: Verificar que hay datos en cada tabla
SELECT 'TMP_Customers' as tabla, COUNT(*) as registros FROM TMP_Customers
UNION ALL
SELECT 'TMP_Products' as tabla, COUNT(*) as registros FROM TMP_Products
UNION ALL
SELECT 'TMP_Orders' as tabla, COUNT(*) as registros FROM TMP_Orders
UNION ALL
SELECT 'TMP_OrderDetails' as tabla, COUNT(*) as registros FROM TMP_OrderDetails;

-- Control 2: Verificar campos clave no nulos
SELECT 'Customers sin ID' as problema, COUNT(*) as cantidad 
FROM TMP_Customers WHERE customerID IS NULL
UNION ALL
SELECT 'Products sin ID' as problema, COUNT(*) as cantidad 
FROM TMP_Products WHERE productID IS NULL
UNION ALL
SELECT 'Orders sin ID' as problema, COUNT(*) as cantidad 
FROM TMP_Orders WHERE orderID IS NULL;

-- Control 3: Verificar relaciones basicas
SELECT 'Orders sin Customer valido' as problema, COUNT(*) as cantidad
FROM TMP_Orders o 
WHERE o.customerID NOT IN (SELECT customerID FROM TMP_Customers)
UNION ALL
SELECT 'OrderDetails sin Order valido' as problema, COUNT(*) as cantidad
FROM TMP_OrderDetails od 
WHERE od.orderID NOT IN (SELECT orderID FROM TMP_Orders); 