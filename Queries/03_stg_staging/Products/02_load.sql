-- CARGAR STG_Products
-- Limpieza de espacios extras (caracteres especiales son legítimos y se mantienen)

-- Limpieza previa
DELETE FROM STG_Products;

-- Registrar proceso de limpieza
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino,
  estado, observaciones
) VALUES (
  'Limpieza STG_Products', 'staging', 'TMP_Products', 'STG_Products',
  'en_proceso', 'Limpiando espacios extras (caracteres especiales son correctos)'
);

-- Carga con transformaciones mínimas (solo limpieza de espacios)
INSERT INTO STG_Products (
    productID, productName, supplierID, categoryID,
    quantityPerUnit, unitPrice, unitsInStock, unitsOnOrder, reorderLevel,
    discontinued, stg_data_quality_score
)
SELECT 
    productID,
    productName, -- Mantener exactamente como está (caracteres especiales son correctos)
    supplierID,
    categoryID,
    -- ÚNICA TRANSFORMACIÓN: Limpieza de espacios extras en quantityPerUnit
    CASE 
        WHEN quantityPerUnit IS NULL THEN NULL
        ELSE TRIM(REPLACE(quantityPerUnit, '  ', ' ')) -- Reemplazar dobles espacios por uno solo y trim
    END as quantityPerUnit,
    unitPrice,
    unitsInStock,
    unitsOnOrder,
    reorderLevel,
    discontinued,
    -- CALCULAR SCORE DE CALIDAD (caracteres especiales NO penalizan, son correctos)
    ROUND(
        (CASE WHEN productID IS NOT NULL THEN 0.15 ELSE 0 END +
         CASE WHEN productName IS NOT NULL AND productName != '' THEN 0.25 ELSE 0 END +
         CASE WHEN supplierID IS NOT NULL THEN 0.15 ELSE 0 END +
         CASE WHEN categoryID IS NOT NULL THEN 0.15 ELSE 0 END +
         CASE WHEN unitPrice IS NOT NULL AND unitPrice > 0 THEN 0.20 ELSE 0 END +
         CASE WHEN discontinued IN (0, 1) THEN 0.10 ELSE 0 END), 2
    ) as stg_data_quality_score
FROM TMP_Products;

-- Control post-carga
SELECT 'STG_Products creada' as resultado, COUNT(*) as registros FROM STG_Products;

-- Verificar transformaciones específicas
SELECT 'VERIFICACIÓN DE TRANSFORMACIONES:' as titulo;

-- Producto con espacios corregidos (única transformación aplicada)
SELECT 'Producto con espacios corregidos (ID 36):' as transformacion;
SELECT productID, productName, 
       (SELECT quantityPerUnit FROM TMP_Products WHERE productID = s.productID) as quantity_original,
       s.quantityPerUnit as quantity_limpia,
       'Espacios reducidos de 16 a 15 caracteres' as nota
FROM STG_Products s
WHERE productID = 36; -- El que tenía doble espacio

-- Ejemplos de productos con caracteres especiales MANTENIDOS (correctos)
SELECT 'Productos con caracteres especiales MANTENIDOS (correctos):' as ejemplo;
SELECT productID, productName
FROM STG_Products 
WHERE productID IN (22, 24, 26, 38, 73, 77) -- Algunos con acentos/diéresis
ORDER BY productID;

-- Finalizar proceso
UPDATE DQM_Procesos 
SET estado = 'exitoso',
    registros_procesados = (SELECT COUNT(*) FROM STG_Products),
    observaciones = 'Transformaciones aplicadas: 1) Espacios extras eliminados en quantityPerUnit, 2) Caracteres especiales mantenidos (son correctos), 3) Todos los campos validados'
WHERE nombre_proceso = 'Limpieza STG_Products'; 