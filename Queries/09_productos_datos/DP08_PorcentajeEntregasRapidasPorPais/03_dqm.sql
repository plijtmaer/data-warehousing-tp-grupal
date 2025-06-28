-- Registrar publicación del producto de datos en DQM_Procesos

INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino, estado, registros_procesados, observaciones
)
VALUES (
  'Publicación DP08_PorcentajeEntregasRapidasPorPais',
  'producto_dato',
  'DWH_*',
  'DP08_PorcentajeEntregasRapidasPorPais',
  'exitoso',
  (SELECT COUNT(*) FROM DP08_PorcentajeEntregasRapidasPorPais),
  'Porcentaje de entregas rápidas por país publicado correctamente.'
);
