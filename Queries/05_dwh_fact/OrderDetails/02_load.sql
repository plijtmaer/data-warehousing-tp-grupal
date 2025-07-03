-- Control: verificar detalles a cargar
SELECT COUNT(*) as total_details FROM STG_OrderDetails;

-- Control: verificar descuentos invalidos
SELECT COUNT(*) as descuentos_invalidos FROM STG_OrderDetails WHERE discount < 0 OR discount > 1;

-- Limpieza previa: elimina registros duplicados que ya existan
DELETE FROM DWH_Fact_OrderDetails
WHERE orderID IN (SELECT orderID FROM STG_OrderDetails);

-- Inserción desde STG_OrderDetails (staging layer)
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
FROM STG_OrderDetails od;

-- Control posterior: verificar carga de detalles
SELECT COUNT(*) as details_cargados FROM DWH_Fact_OrderDetails;
