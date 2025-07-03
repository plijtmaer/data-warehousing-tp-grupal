-- CREAR STG_OrderDetails
-- Copia directa de TMP_OrderDetails (datos ya limpios)

CREATE TABLE IF NOT EXISTS STG_OrderDetails (
    orderID INTEGER,
    productID INTEGER,
    unitPrice REAL,
    quantity INTEGER,
    discount REAL,
    -- Campos de auditoría staging
    stg_created_date DATE DEFAULT CURRENT_DATE,
    stg_data_quality_score REAL DEFAULT 1.0,
    PRIMARY KEY (orderID, productID)
); 