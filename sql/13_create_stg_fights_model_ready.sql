CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.stg_fights_model_ready` AS
WITH med AS (
  SELECT
    (SELECT APPROX_QUANTILES(r_age, 100)[OFFSET(50)]
     FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched`
     WHERE r_age IS NOT NULL) AS r_age_med,
    (SELECT APPROX_QUANTILES(b_age, 100)[OFFSET(50)]
     FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched`
     WHERE b_age IS NOT NULL) AS b_age_med,
    (SELECT APPROX_QUANTILES(r_reach, 100)[OFFSET(50)]
     FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched`
     WHERE r_reach IS NOT NULL) AS r_reach_med,
    (SELECT APPROX_QUANTILES(b_reach, 100)[OFFSET(50)]
     FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched`
     WHERE b_reach IS NOT NULL) AS b_reach_med,
    (SELECT APPROX_QUANTILES(r_height, 100)[OFFSET(50)]
     FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched`
     WHERE r_height IS NOT NULL) AS r_height_med,
    (SELECT APPROX_QUANTILES(b_height, 100)[OFFSET(50)]
     FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched`
     WHERE b_height IS NOT NULL) AS b_height_med
)
SELECT
  f.*,
  IFNULL(f.r_age, med.r_age_med) AS r_age_imputed,
  IFNULL(f.b_age, med.b_age_med) AS b_age_imputed,
  IFNULL(f.r_reach, med.r_reach_med) AS r_reach_imputed,
  IFNULL(f.b_reach, med.b_reach_med) AS b_reach_imputed,
  IFNULL(f.r_height, med.r_height_med) AS r_height_imputed,
  IFNULL(f.b_height, med.b_height_med) AS b_height_imputed,
  IFNULL(f.r_stance, 'unknown') AS r_stance_imputed,
  IFNULL(f.b_stance, 'unknown') AS b_stance_imputed,
  IF(f.r_age IS NULL, 1, 0) AS r_age_missing,
  IF(f.b_age IS NULL, 1, 0) AS b_age_missing,
  IF(f.r_reach IS NULL, 1, 0) AS r_reach_missing,
  IF(f.b_reach IS NULL, 1, 0) AS b_reach_missing,
  IF(f.r_height IS NULL, 1, 0) AS r_height_missing,
  IF(f.b_height IS NULL, 1, 0) AS b_height_missing,
  IF(f.r_stance IS NULL, 1, 0) AS r_stance_missing,
  IF(f.b_stance IS NULL, 1, 0) AS b_stance_missing
FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched` f
CROSS JOIN med;