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
