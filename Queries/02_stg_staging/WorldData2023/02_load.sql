-- CARGAR STG_WorldData2023
-- Limpieza y transformación de datos desde TMP_WorldData2023

-- Limpieza previa
DELETE FROM STG_WorldData2023;

-- Registrar proceso de limpieza
INSERT INTO DQM_Procesos (
  nombre_proceso, tipo_proceso, tabla_origen, tabla_destino,
  estado, observaciones
) VALUES (
  'Limpieza STG_WorldData2023', 'staging', 'TMP_WorldData2023', 'STG_WorldData2023',
  'en_proceso', 'Aplicando transformaciones de limpieza de datos'
);

-- Carga con transformaciones COMPLETAS
INSERT INTO STG_WorldData2023 (
    country, density_pkm2, abbreviation, agricultural_land_pct, land_area_km2,
    armed_forces_size, birth_rate, calling_code, capital_major_city, co2_emissions,
    cpi, cpi_change_pct, currency_code, fertility_rate, forested_area_pct,
    gasoline_price, gdp, gross_primary_enrollment_pct, gross_tertiary_enrollment_pct,
    infant_mortality, largest_city, life_expectancy, maternal_mortality_ratio,
    minimum_wage, official_language, out_of_pocket_expenditure, physicians_per_thousand,
    population, labor_force_participation_pct, tax_revenue_pct, total_tax_rate,
    unemployment_rate, urban_population, latitude, longitude, stg_data_quality_score
)
SELECT 
    -- 1. ESTANDARIZACIÓN DE PAÍSES (adaptar WorldData2023 al sistema transaccional)
    CASE 
        WHEN country = 'United States' THEN 'USA'
        WHEN country = 'United Kingdom' THEN 'UK'
        WHEN country = 'Republic of Ireland' THEN 'Ireland'
        WHEN country LIKE 'S�����������' THEN 'São Tomé and Príncipe'  -- Fix encoding corrupto
        ELSE country
    END as country,
    -- Limpieza de campos numéricos: eliminar caracteres no numéricos y convertir
    CASE 
        WHEN density_pkm2 IS NULL OR density_pkm2 = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(density_pkm2, ',', ''), '$', '') AS REAL)
    END as density_pkm2,
    abbreviation,
    CASE 
        WHEN agricultural_land_pct IS NULL OR agricultural_land_pct = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(agricultural_land_pct, ',', ''), '%', '') AS REAL)
    END as agricultural_land_pct,
    CASE 
        WHEN land_area_km2 IS NULL OR land_area_km2 = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(land_area_km2, ',', ''), '$', '') AS REAL)
    END as land_area_km2,
    CASE 
        WHEN armed_forces_size IS NULL OR armed_forces_size = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(armed_forces_size, ',', ''), '$', '') AS INTEGER)
    END as armed_forces_size,
    CASE 
        WHEN birth_rate IS NULL OR birth_rate = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(birth_rate, ',', ''), '$', '') AS REAL)
    END as birth_rate,
    calling_code,
    -- 2. CORRECCIÓN DE ENCODING UTF-8 EN CIUDADES
    CASE 
        WHEN capital_major_city LIKE 'Bras���%' THEN 'Brasília'
        WHEN capital_major_city LIKE 'Bogot�%' THEN 'Bogotá'
        WHEN capital_major_city LIKE 'San Jos������%' THEN 'San José'
        WHEN capital_major_city LIKE 'Reykjav��%' THEN 'Reykjavík'
        WHEN capital_major_city LIKE 'Mal�%' THEN 'Malé'
        WHEN capital_major_city LIKE 'Chi����%' THEN 'Chișinău'
        WHEN capital_major_city LIKE 'Asunci��%' THEN 'Asunción'
        WHEN capital_major_city LIKE 'Lom�%' THEN 'Lomé'
        WHEN capital_major_city LIKE 'Nuku����%' THEN 'Nuku''alofa'
        WHEN capital_major_city LIKE 'S����%' THEN 'São Tomé'
        ELSE capital_major_city
    END as capital_major_city,
    CASE 
        WHEN co2_emissions IS NULL OR co2_emissions = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(co2_emissions, ',', ''), '$', '') AS REAL)
    END as co2_emissions,
    CASE 
        WHEN cpi IS NULL OR cpi = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(cpi, ',', ''), '$', '') AS REAL)
    END as cpi,
    CASE 
        WHEN cpi_change_pct IS NULL OR cpi_change_pct = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(REPLACE(cpi_change_pct, ',', ''), '$', ''), '%', '') AS REAL)
    END as cpi_change_pct,
    currency_code,
    CASE 
        WHEN fertility_rate IS NULL OR fertility_rate = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(fertility_rate, ',', ''), '$', '') AS REAL)
    END as fertility_rate,
    CASE 
        WHEN forested_area_pct IS NULL OR forested_area_pct = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(REPLACE(forested_area_pct, ',', ''), '$', ''), '%', '') AS REAL)
    END as forested_area_pct,
    CASE 
        WHEN gasoline_price IS NULL OR gasoline_price = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(gasoline_price, ',', ''), '$', '') AS REAL)
    END as gasoline_price,
    -- GDP: Limpieza especial para formato $19,101,353,833
    CASE 
        WHEN gdp IS NULL OR gdp = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(REPLACE(TRIM(gdp), '$', ''), ',', ''), ' ', '') AS REAL)
    END as gdp,
    CASE 
        WHEN gross_primary_enrollment_pct IS NULL OR gross_primary_enrollment_pct = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(REPLACE(gross_primary_enrollment_pct, ',', ''), '$', ''), '%', '') AS REAL)
    END as gross_primary_enrollment_pct,
    CASE 
        WHEN gross_tertiary_enrollment_pct IS NULL OR gross_tertiary_enrollment_pct = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(REPLACE(gross_tertiary_enrollment_pct, ',', ''), '$', ''), '%', '') AS REAL)
    END as gross_tertiary_enrollment_pct,
    CASE 
        WHEN infant_mortality IS NULL OR infant_mortality = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(infant_mortality, ',', ''), '$', '') AS REAL)
    END as infant_mortality,
    -- 3. CORRECCIÓN DE ENCODING UTF-8 EN LARGEST_CITY
    CASE 
        WHEN largest_city LIKE 'S����%' THEN 'São Paulo'
        WHEN largest_city LIKE 'Bogot�%' THEN 'Bogotá'
        WHEN largest_city LIKE 'San Jos������%' THEN 'San José'
        WHEN largest_city LIKE 'Statos�������%' THEN 'Nicosia'  -- Cyprus largest city
        WHEN largest_city LIKE 'Reykjav��%' THEN 'Reykjavík'
        WHEN largest_city LIKE 'Mal�%' THEN 'Malé'
        WHEN largest_city LIKE 'Chi����%' THEN 'Chișinău'
        WHEN largest_city LIKE 'S�����%' THEN 'Stockholm'  -- Sweden
        WHEN largest_city LIKE 'Z���%' THEN 'Zürich'
        WHEN largest_city LIKE 'Lom�%' THEN 'Lomé'
        WHEN largest_city LIKE 'Nuku����%' THEN 'Nuku''alofa'
        WHEN largest_city LIKE 'S����%' AND country LIKE 'S�%' THEN 'São Tomé'
        ELSE largest_city
    END as largest_city,
    life_expectancy, -- Ya está como REAL en la fuente
    CASE 
        WHEN maternal_mortality_ratio IS NULL OR maternal_mortality_ratio = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(maternal_mortality_ratio, ',', ''), '$', '') AS REAL)
    END as maternal_mortality_ratio,
    CASE 
        WHEN minimum_wage IS NULL OR minimum_wage = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(minimum_wage, ',', ''), '$', '') AS REAL)
    END as minimum_wage,
    official_language,
    CASE 
        WHEN out_of_pocket_expenditure IS NULL OR out_of_pocket_expenditure = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(out_of_pocket_expenditure, ',', ''), '$', '') AS REAL)
    END as out_of_pocket_expenditure,
    CASE 
        WHEN physicians_per_thousand IS NULL OR physicians_per_thousand = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(physicians_per_thousand, ',', ''), '$', '') AS REAL)
    END as physicians_per_thousand,
    -- Population: Limpieza especial para formato 38,041,754
    CASE 
        WHEN population IS NULL OR population = '' THEN NULL
        ELSE CAST(REPLACE(population, ',', '') AS INTEGER)
    END as population,
    CASE 
        WHEN labor_force_participation_pct IS NULL OR labor_force_participation_pct = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(REPLACE(labor_force_participation_pct, ',', ''), '$', ''), '%', '') AS REAL)
    END as labor_force_participation_pct,
    CASE 
        WHEN tax_revenue_pct IS NULL OR tax_revenue_pct = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(REPLACE(tax_revenue_pct, ',', ''), '$', ''), '%', '') AS REAL)
    END as tax_revenue_pct,
    CASE 
        WHEN total_tax_rate IS NULL OR total_tax_rate = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(REPLACE(total_tax_rate, ',', ''), '$', ''), '%', '') AS REAL)
    END as total_tax_rate,
    CASE 
        WHEN unemployment_rate IS NULL OR unemployment_rate = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(REPLACE(unemployment_rate, ',', ''), '$', ''), '%', '') AS REAL)
    END as unemployment_rate,
    CASE 
        WHEN urban_population IS NULL OR urban_population = '' THEN NULL
        ELSE CAST(REPLACE(urban_population, ',', '') AS INTEGER)
    END as urban_population,
    latitude,  -- Ya está como REAL
    longitude, -- Ya está como REAL
    -- Calcular score de calidad basado en campos críticos no nulos
    ROUND(
        (CASE WHEN population IS NOT NULL AND population != '' THEN 0.3 ELSE 0 END +
         CASE WHEN gdp IS NOT NULL AND gdp != '' THEN 0.3 ELSE 0 END +
         CASE WHEN life_expectancy IS NOT NULL THEN 0.2 ELSE 0 END +
         CASE WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN 0.2 ELSE 0 END), 2
    ) as stg_data_quality_score
FROM TMP_WorldData2023;

-- Control post-carga
SELECT 'STG_WorldData2023 creada' as resultado, COUNT(*) as registros FROM STG_WorldData2023;

-- Finalizar proceso
UPDATE DQM_Procesos 
SET estado = 'exitoso',
    registros_procesados = (SELECT COUNT(*) FROM STG_WorldData2023),
    observaciones = 'Transformaciones aplicadas: 1) Países estandarizados (USA,UK,Ireland), 2) Encoding UTF-8 corregido (14 países), 3) Campos numéricos limpios (GDP, población), 4) Ciudades con acentos restaurados'
WHERE nombre_proceso = 'Limpieza STG_WorldData2023'; 