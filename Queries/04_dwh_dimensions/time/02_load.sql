-- Borrado total previo de registros para evitar duplicados
DELETE FROM DWH_Dim_Time;

-- Generación de fechas día por día utilizando una CTE recursiva.
-- En SQLite no existe una función nativa para generar series de fechas.
-- Por eso se utiliza una CTE recursiva para crear un rango diario entre dos fechas.
WITH RECURSIVE fechas(fecha) AS (
  SELECT DATE('1995-01-01')                     -- Fecha inicial
  UNION ALL
  SELECT DATE(fecha, '+1 day')                  -- Suma un día en cada iteración
  FROM fechas
  WHERE fecha < DATE('2025-12-31')              -- Fecha final
)

-- Inserción de las fechas generadas junto con atributos derivados
INSERT INTO DWH_Dim_Time
SELECT
  fecha AS date,                                -- Fecha completa (clave primaria)
  STRFTIME('%Y', fecha) AS year,                -- Año
  STRFTIME('%m', fecha) AS month,               -- Mes numérico

  -- Traducción de número de mes a nombre en español
  CASE STRFTIME('%m', fecha)
    WHEN '01' THEN 'Enero'
    WHEN '02' THEN 'Febrero'
    WHEN '03' THEN 'Marzo'
    WHEN '04' THEN 'Abril'
    WHEN '05' THEN 'Mayo'
    WHEN '06' THEN 'Junio'
    WHEN '07' THEN 'Julio'
    WHEN '08' THEN 'Agosto'
    WHEN '09' THEN 'Septiembre'
    WHEN '10' THEN 'Octubre'
    WHEN '11' THEN 'Noviembre'
    WHEN '12' THEN 'Diciembre'
  END AS month_name,

  -- Trimestre (1 a 4)
  ((CAST(STRFTIME('%m', fecha) AS INTEGER) - 1) / 3 + 1) AS quarter,

  STRFTIME('%d', fecha) AS day,                 -- Día del mes

  -- Día de la semana como número (0=Domingo, 6=Sábado)
  STRFTIME('%w', fecha) AS weekday,

  -- Día de la semana como texto
  CASE STRFTIME('%w', fecha)
    WHEN '0' THEN 'Domingo'
    WHEN '1' THEN 'Lunes'
    WHEN '2' THEN 'Martes'
    WHEN '3' THEN 'Miércoles'
    WHEN '4' THEN 'Jueves'
    WHEN '5' THEN 'Viernes'
    WHEN '6' THEN 'Sábado'
  END AS weekday_name,

  -- Indicador de fin de semana ('Sí' o 'No')
  CASE STRFTIME('%w', fecha)
    WHEN '0' THEN 'Sí'
    WHEN '6' THEN 'Sí'
    ELSE 'No'
  END AS is_weekend

FROM fechas;
