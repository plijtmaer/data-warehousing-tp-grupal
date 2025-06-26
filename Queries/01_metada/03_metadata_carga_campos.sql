
-- CARGA DE METADATA DE CAMPOS

-- DWH_Dim_Customers
INSERT INTO MET_Campos VALUES
('DWH_Dim_Customers', 'customerID', 'TEXT', 'Identificador del cliente', 'Sí', 'No'),
('DWH_Dim_Customers', 'companyName', 'TEXT', 'Nombre de la empresa', 'No', 'No'),
('DWH_Dim_Customers', 'contactName', 'TEXT', 'Nombre del contacto', 'No', 'Sí'),
('DWH_Dim_Customers', 'country', 'TEXT', 'País del cliente', 'No', 'No'),
('DWH_Dim_Customers', 'city', 'TEXT', 'Ciudad del cliente', 'No', 'Sí');

-- DWH_Dim_Employees
INSERT INTO MET_Campos VALUES
('DWH_Dim_Employees', 'employeeID', 'INTEGER', 'Identificador del empleado', 'Sí', 'No'),
('DWH_Dim_Employees', 'lastName', 'TEXT', 'Apellido del empleado', 'No', 'No'),
('DWH_Dim_Employees', 'firstName', 'TEXT', 'Nombre del empleado', 'No', 'No'),
('DWH_Dim_Employees', 'title', 'TEXT', 'Puesto o cargo', 'No', 'Sí'),
('DWH_Dim_Employees', 'titleOfCourtesy', 'TEXT', 'Tratamiento formal (Mr., Ms., etc.)', 'No', 'Sí'),
('DWH_Dim_Employees', 'birthDate', 'TEXT', 'Fecha de nacimiento', 'No', 'Sí'),
('DWH_Dim_Employees', 'hireDate', 'TEXT', 'Fecha de contratación', 'No', 'Sí'),
('DWH_Dim_Employees', 'address', 'TEXT', 'Dirección', 'No', 'Sí'),
('DWH_Dim_Employees', 'city', 'TEXT', 'Ciudad', 'No', 'Sí'),
('DWH_Dim_Employees', 'region', 'TEXT', 'Región', 'No', 'Sí'),
('DWH_Dim_Employees', 'postalCode', 'TEXT', 'Código postal', 'No', 'Sí'),
('DWH_Dim_Employees', 'country', 'TEXT', 'País', 'No', 'Sí'),
('DWH_Dim_Employees', 'homePhone', 'TEXT', 'Teléfono particular', 'No', 'Sí'),
('DWH_Dim_Employees', 'extension', 'TEXT', 'Extensión telefónica', 'No', 'Sí'),
('DWH_Dim_Employees', 'notes', 'TEXT', 'Notas adicionales', 'No', 'Sí'),
('DWH_Dim_Employees', 'reportsTo', 'INTEGER', 'Identificador del jefe directo', 'No', 'Sí');

-- DWH_Dim_Products
INSERT INTO MET_Campos VALUES
('DWH_Dim_Products', 'productID', 'INTEGER', 'Identificador del producto', 'Sí', 'No'),
('DWH_Dim_Products', 'productName', 'TEXT', 'Nombre del producto', 'No', 'No'),
('DWH_Dim_Products', 'supplierID', 'INTEGER', 'Identificador del proveedor', 'No', 'Sí'),
('DWH_Dim_Products', 'categoryID', 'INTEGER', 'Identificador de la categoría', 'No', 'Sí'),
('DWH_Dim_Products', 'quantityPerUnit', 'TEXT', 'Cantidad por unidad', 'No', 'Sí'),
('DWH_Dim_Products', 'unitPrice', 'REAL', 'Precio por unidad', 'No', 'Sí'),
('DWH_Dim_Products', 'unitsInStock', 'INTEGER', 'Unidades en stock', 'No', 'Sí'),
('DWH_Dim_Products', 'unitsOnOrder', 'INTEGER', 'Unidades en pedido', 'No', 'Sí'),
('DWH_Dim_Products', 'reorderLevel', 'INTEGER', 'Nivel mínimo de stock', 'No', 'Sí'),
('DWH_Dim_Products', 'discontinued', 'INTEGER', 'Indica si el producto está descontinuado', 'No', 'Sí');

-- DWH_Dim_Suppliers
INSERT INTO MET_Campos VALUES
('DWH_Dim_Suppliers', 'supplierID', 'INTEGER', 'Identificador del proveedor', 'Sí', 'No'),
('DWH_Dim_Suppliers', 'companyName', 'TEXT', 'Nombre de la empresa proveedora', 'No', 'No'),
('DWH_Dim_Suppliers', 'contactName', 'TEXT', 'Nombre del contacto', 'No', 'Sí'),
('DWH_Dim_Suppliers', 'country', 'TEXT', 'País del proveedor', 'No', 'Sí'),
('DWH_Dim_Suppliers', 'city', 'TEXT', 'Ciudad del proveedor', 'No', 'Sí');

-- DWH_Dim_Shippers
INSERT INTO MET_Campos VALUES
('DWH_Dim_Shippers', 'shipperID', 'INTEGER', 'Identificador del transportista', 'Sí', 'No'),
('DWH_Dim_Shippers', 'companyName', 'TEXT', 'Nombre de la empresa de envíos', 'No', 'No'),
('DWH_Dim_Shippers', 'phone', 'TEXT', 'Teléfono de contacto', 'No', 'Sí');

-- DWH_Dim_Categories
INSERT INTO MET_Campos VALUES
('DWH_Dim_Categories', 'categoryID', 'INTEGER', 'Identificador de la categoría', 'Sí', 'No'),
('DWH_Dim_Categories', 'categoryName', 'TEXT', 'Nombre de la categoría', 'No', 'No'),
('DWH_Dim_Categories', 'description', 'TEXT', 'Descripción de la categoría', 'No', 'Sí');

-- DWH_Dim_Regions
INSERT INTO MET_Campos VALUES
('DWH_Dim_Regions', 'regionID', 'INTEGER', 'Identificador de la región', 'Sí', 'No'),
('DWH_Dim_Regions', 'regionDescription', 'TEXT', 'Descripción de la región', 'No', 'No');

-- DWH_Dim_Territories
INSERT INTO MET_Campos VALUES
('DWH_Dim_Territories', 'territoryID', 'TEXT', 'Identificador del territorio', 'Sí', 'No'),
('DWH_Dim_Territories', 'territoryDescription', 'TEXT', 'Descripción del territorio', 'No', 'No'),
('DWH_Dim_Territories', 'regionID', 'INTEGER', 'Región asociada al territorio', 'No', 'No');

-- DWH_Dim_Countries
INSERT INTO MET_Campos VALUES
('DWH_Dim_Countries', 'country', 'TEXT', 'Nombre del país', 'Sí', 'No'),
('DWH_Dim_Countries', 'population', 'INTEGER', 'Población total', 'No', 'Sí'),
('DWH_Dim_Countries', 'gdp', 'REAL', 'Producto Bruto Interno (GDP)', 'No', 'Sí'),
('DWH_Dim_Countries', 'life_expectancy', 'REAL', 'Esperanza de vida', 'No', 'Sí'),
('DWH_Dim_Countries', 'latitude', 'REAL', 'Latitud geográfica', 'No', 'Sí'),
('DWH_Dim_Countries', 'longitude', 'REAL', 'Longitud geográfica', 'No', 'Sí');

-- DWH_Dim_Time
INSERT INTO MET_Campos VALUES
('DWH_Dim_Time', 'date', 'DATE', 'Fecha en formato calendario', 'Sí', 'No'),
('DWH_Dim_Time', 'day', 'INTEGER', 'Día del mes', 'No', 'No'),
('DWH_Dim_Time', 'month', 'INTEGER', 'Mes', 'No', 'No'),
('DWH_Dim_Time', 'year', 'INTEGER', 'Año', 'No', 'No'),
('DWH_Dim_Time', 'quarter', 'INTEGER', 'Trimestre', 'No', 'No'),
('DWH_Dim_Time', 'week', 'INTEGER', 'Semana del año', 'No', 'No'),
('DWH_Dim_Time', 'dayOfWeek', 'INTEGER', 'Día de la semana (1=Domingo)', 'No', 'No'),
('DWH_Dim_Time', 'isWeekend', 'INTEGER', 'Indicador de fin de semana (0/1)', 'No', 'No');

-- DWH_Fact_Orders
INSERT INTO MET_Campos VALUES
('DWH_Fact_Orders', 'orderID', 'INTEGER', 'Identificador único del pedido', 'Sí', 'No'),
('DWH_Fact_Orders', 'customerID', 'TEXT', 'Cliente que realizó el pedido', 'No', 'Sí'),
('DWH_Fact_Orders', 'employeeID', 'INTEGER', 'Empleado que gestionó el pedido', 'No', 'Sí'),
('DWH_Fact_Orders', 'shipperID', 'INTEGER', 'Empresa transportista', 'No', 'Sí'),
('DWH_Fact_Orders', 'orderDate', 'DATE', 'Fecha del pedido', 'No', 'Sí'),
('DWH_Fact_Orders', 'requiredDate', 'DATE', 'Fecha requerida de entrega', 'No', 'Sí'),
('DWH_Fact_Orders', 'shippedDate', 'DATE', 'Fecha de despacho del pedido', 'No', 'Sí'),
('DWH_Fact_Orders', 'freight', 'REAL', 'Costo de envío (flete)', 'No', 'Sí');

-- DWH_Fact_OrderDetails
INSERT INTO MET_Campos VALUES
('DWH_Fact_OrderDetails', 'orderID', 'INTEGER', 'ID del pedido', 'Sí', 'No'),
('DWH_Fact_OrderDetails', 'productID', 'INTEGER', 'ID del producto', 'Sí', 'No'),
('DWH_Fact_OrderDetails', 'unitPrice', 'REAL', 'Precio unitario del producto', 'No', 'No'),
('DWH_Fact_OrderDetails', 'quantity', 'INTEGER', 'Cantidad pedida', 'No', 'No'),
('DWH_Fact_OrderDetails', 'discount', 'REAL', 'Descuento aplicado', 'No', 'Sí'),
('DWH_Fact_OrderDetails', 'totalPrice', 'REAL', 'Total calculado del detalle', 'No', 'Sí');
