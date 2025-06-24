-- Tabla de descripción general de entidades
CREATE TABLE IF NOT EXISTS MET_Tablas (
  nombre_tabla TEXT PRIMARY KEY,
  descripcion TEXT,
  tipo TEXT,
  fecha_creacion TEXT,
  creado_por TEXT,
  comentarios TEXT
);

-- Tabla de descripción de campos por entidad
CREATE TABLE IF NOT EXISTS MET_Campos (
  nombre_tabla TEXT,
  nombre_campo TEXT,
  tipo_dato TEXT,
  descripcion TEXT,
  origen TEXT,
  validaciones TEXT,
  PRIMARY KEY (nombre_tabla, nombre_campo),
  FOREIGN KEY (nombre_tabla) REFERENCES MET_Tablas(nombre_tabla)
);
