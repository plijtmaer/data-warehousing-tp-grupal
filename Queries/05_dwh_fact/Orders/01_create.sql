-- Eliminación previa en caso de que la tabla ya exista
DROP TABLE IF EXISTS DWH_Fact_Orders;

-- Creación de tabla de hechos de órdenes (nivel pedido)
CREATE TABLE DWH_Fact_Orders (
  orderID INTEGER PRIMARY KEY,        -- Identificador único del pedido
  customerID TEXT,                    -- Cliente que realizó el pedido
  employeeID INTEGER,                 -- Empleado que gestionó el pedido
  shipperID INTEGER,                  -- Empresa transportista (shipVia)
  orderDate DATE,                     -- Fecha en que se realizó el pedido
  requiredDate DATE,                  -- Fecha solicitada de entrega
  shippedDate DATE,                   -- Fecha en que se despachó el pedido
  freight REAL                        -- Costo del envío (flete)
);
