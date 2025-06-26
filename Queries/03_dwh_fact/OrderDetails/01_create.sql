-- Eliminación previa si la tabla ya existe

DROP TABLE IF EXISTS DWH_Fact_OrderDetails;

-- Creación de la tabla de hechos de detalles de pedidos (nivel pedido-producto)

CREATE TABLE DWH_Fact_OrderDetails (
  orderID INTEGER,                -- Identificador del pedido (FK a DWH_Fact_Orders)
  productID INTEGER,              -- Producto vendido (FK a DWH_Dim_Products)
  quantity INTEGER,               -- Cantidad vendida
  unitPrice REAL,                 -- Precio unitario al momento del pedido
  discount REAL,                  -- Porcentaje de descuento aplicado (0 a 1)
  totalPrice REAL,                -- Monto total = (unitPrice * quantity) * (1 - discount)
  PRIMARY KEY (orderID, productID)  -- Clave compuesta: un producto por pedido
);
