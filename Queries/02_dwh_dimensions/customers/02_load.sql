-- Control previo: verificar que hay datos para cargar
SELECT COUNT(*) as total_customers FROM TMP_Customers;

-- Control: verificar que no hay customerID nulos
SELECT COUNT(*) as customers_sin_id FROM TMP_Customers WHERE customerID IS NULL;

-- Limpieza previa: elimina los registros con customerID ya existentes para evitar duplicados
DELETE FROM DWH_Dim_Customers
WHERE customerID IN (SELECT customerID FROM TMP_Customers);

-- Inserta los nuevos y actualizados
INSERT INTO DWH_Dim_Customers
SELECT
  customerID,
  companyName,
  contactName,
  contactTitle,
  address,
  city,
  region,
  postalCode,
  country,
  phone,
  fax
FROM TMP_Customers;

-- Control posterior: verificar que se cargaron los datos
SELECT COUNT(*) as customers_cargados FROM DWH_Dim_Customers;
