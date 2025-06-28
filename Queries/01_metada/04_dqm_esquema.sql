-- SISTEMA DE DATA QUALITY MANAGEMENT (DQM)
-- Punto 7 de la consigna: DQM para persistir procesos, descriptivos e indicadores

-- Tabla para registrar procesos ejecutados sobre el DWA
CREATE TABLE IF NOT EXISTS DQM_Procesos (
  proceso_id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre_proceso TEXT NOT NULL,
  tipo_proceso TEXT, -- 'ingesta', 'integracion', 'carga', 'validacion'
  tabla_origen TEXT,
  tabla_destino TEXT,
  fecha_ejecucion DATETIME DEFAULT CURRENT_TIMESTAMP,
  estado TEXT, -- 'exitoso', 'fallido', 'advertencia'
  registros_procesados INTEGER,
  registros_exitosos INTEGER,
  registros_rechazados INTEGER,
  tiempo_ejecucion_seg REAL,
  observaciones TEXT
);

-- Tabla para descriptivos de cada entidad procesada
CREATE TABLE IF NOT EXISTS DQM_Descriptivos (
  descriptivo_id INTEGER PRIMARY KEY AUTOINCREMENT,
  proceso_id INTEGER,
  tabla_nombre TEXT NOT NULL,
  campo_nombre TEXT,
  total_registros INTEGER,
  registros_nulos INTEGER,
  registros_vacios INTEGER,
  valores_unicos INTEGER,
  valor_minimo TEXT,
  valor_maximo TEXT,
  promedio REAL,
  fecha_analisis DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (proceso_id) REFERENCES DQM_Procesos(proceso_id)
);

-- Tabla para indicadores de calidad
CREATE TABLE IF NOT EXISTS DQM_Indicadores (
  indicador_id INTEGER PRIMARY KEY AUTOINCREMENT,
  proceso_id INTEGER,
  tipo_indicador TEXT, -- 'completitud', 'unicidad', 'integridad', 'consistencia', 'precision'
  tabla_nombre TEXT,
  campo_nombre TEXT,
  valor_indicador REAL, -- porcentaje o valor numérico
  umbral_minimo REAL,   -- límite inferior aceptable
  umbral_maximo REAL,   -- límite superior aceptable
  resultado TEXT,       -- 'aprobado', 'rechazado', 'advertencia'
  descripcion TEXT,
  fecha_verificacion DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (proceso_id) REFERENCES DQM_Procesos(proceso_id)
);

-- Tabla para reglas de calidad configurables
CREATE TABLE IF NOT EXISTS DQM_Reglas (
  regla_id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre_regla TEXT NOT NULL,
  tipo_regla TEXT, -- 'formato', 'rango', 'obligatorio', 'referencial'
  tabla_aplicable TEXT,
  campo_aplicable TEXT,
  expresion_validacion TEXT, -- SQL o regex
  umbral_aceptacion REAL DEFAULT 95.0, -- porcentaje mínimo para aprobar
  activa INTEGER DEFAULT 1, -- 0=inactiva, 1=activa
  descripcion TEXT,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
