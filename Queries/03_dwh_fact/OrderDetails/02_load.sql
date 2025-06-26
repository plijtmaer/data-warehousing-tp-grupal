-- Limpieza previa: elimina registros duplicados que ya existan

DELETE FROM DWH_Fact_OrderDetails
WHERE orderID IN (SELECT orderID FROM TMP_OrderDetails);

-- Inserción desde la tabla de staging TMP_OrderDetails

INSERT INTO DWH_Fact_OrderDetails (
  orderID,
  productID,
  quantity,
  unitPrice,
  discount,
  totalPrice
)
SELECT
  od.orderID,
  od.productID,
  od.quantity,
  od.unitPrice,
  od.discount,
  ROUND(od.unitPrice * od.quantity * (1 - od.discount), 2) AS totalPrice
FROM TMP_OrderDetails od;
