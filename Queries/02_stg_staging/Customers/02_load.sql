-- CARGAR STG_Customers
-- Copia directa desde TMP_Customers (sin transformaciones necesarias)

-- Limpieza previa
DELETE FROM STG_Customers;

-- Registrar proceso
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino,
  estado, observaciones
) VALUES (
  'Carga STG_Customers', 'staging', 'TMP_Customers', 'STG_Customers',
  'en_proceso', 'Copia directa - datos ya limpios'
);

-- Carga directa sin transformaciones
INSERT INTO STG_Customers (
    customerID, companyName, contactName, contactTitle, 
    address, city, region, postalCode, country, phone, fax,
    stg_data_quality_score
)
SELECT 
    customerID, companyName, contactName, contactTitle,
    address, city, region, postalCode, country, phone, fax,
    -- Score de calidad basado en campos críticos
    ROUND(
        (CASE WHEN customerID IS NOT NULL AND customerID != '' THEN 0.4 ELSE 0 END +
         CASE WHEN companyName IS NOT NULL AND companyName != '' THEN 0.3 ELSE 0 END +
         CASE WHEN country IS NOT NULL AND country != '' THEN 0.3 ELSE 0 END), 2
    ) as stg_data_quality_score
FROM TMP_Customers;

-- Control post-carga
SELECT 'STG_Customers creada' as resultado, COUNT(*) as registros FROM STG_Customers;

-- Finalizar proceso
UPDATE DQM_Procesos 
SET estado = 'exitoso',
    registros_procesados = (SELECT COUNT(*) FROM STG_Customers),
    observaciones = 'Copia directa completada - datos ya estaban limpios'
WHERE nombre_proceso = 'Carga STG_Customers'; 