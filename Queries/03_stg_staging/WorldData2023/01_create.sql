-- CREAR STG_WorldData2023
-- Versión limpia de TMP_WorldData2023 con campos numéricos correctos

CREATE TABLE IF NOT EXISTS STG_WorldData2023 (
    country TEXT PRIMARY KEY,
    density_pkm2 REAL,
    abbreviation TEXT,
    agricultural_land_pct REAL,
    land_area_km2 REAL,
    armed_forces_size INTEGER,
    birth_rate REAL,
    calling_code TEXT,
    capital_major_city TEXT,
    co2_emissions REAL,
    cpi REAL,
    cpi_change_pct REAL,
    currency_code TEXT,
    fertility_rate REAL,
    forested_area_pct REAL,
    gasoline_price REAL,
    gdp REAL,                          -- Limpio: sin $ ni comas
    gross_primary_enrollment_pct REAL,
    gross_tertiary_enrollment_pct REAL,
    infant_mortality REAL,
    largest_city TEXT,
    life_expectancy REAL,
    maternal_mortality_ratio REAL,
    minimum_wage REAL,
    official_language TEXT,
    out_of_pocket_expenditure REAL,
    physicians_per_thousand REAL,
    population INTEGER,                 -- Limpio: sin comas
    labor_force_participation_pct REAL,
    tax_revenue_pct REAL,
    total_tax_rate REAL,
    unemployment_rate REAL,
    urban_population INTEGER,           -- Limpio: sin comas
    latitude REAL,
    longitude REAL,
    -- Campos de metadata para auditoría
    stg_created_date DATE DEFAULT CURRENT_DATE,
    stg_data_quality_score REAL DEFAULT 1.0
); 