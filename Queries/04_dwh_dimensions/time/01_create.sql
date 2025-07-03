-- Creación de tabla dimensional para fechas (calendario)

CREATE TABLE IF NOT EXISTS DWH_Dim_Time (
  date TEXT PRIMARY KEY,         -- formato: YYYY-MM-DD
  year INTEGER,
  month INTEGER,
  month_name TEXT,
  quarter INTEGER,
  day INTEGER,
  weekday INTEGER,               -- 1=Lunes, 7=Domingo
  weekday_name TEXT,
  is_weekend TEXT                -- 'Sí' / 'No'
);