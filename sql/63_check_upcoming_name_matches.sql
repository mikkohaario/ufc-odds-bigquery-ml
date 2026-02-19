WITH manual AS (
  SELECT
    event_date,
    fighter_a,
    fighter_b,
    fighter_a_id,
    fighter_b_id,
    REGEXP_REPLACE(LOWER(TRIM(fighter_a)), r'[^a-z0-9]', '') AS fighter_a_norm,
    REGEXP_REPLACE(LOWER(TRIM(fighter_b)), r'[^a-z0-9]', '') AS fighter_b_norm
  FROM `ufc-odds-ml.ufc_ml.upcoming_fights_manual`
),
fighters AS (
  SELECT
    fighter_id,
    REGEXP_REPLACE(LOWER(TRIM(fighter_name)), r'[^a-z0-9]', '') AS fighter_name_norm
  FROM `ufc-odds-ml.ufc_stg.stg_fighters`
)
SELECT
  m.event_date,
  m.fighter_a,
  m.fighter_b,
  COALESCE(m.fighter_a_id, fa.fighter_id) AS matched_fighter_a_id,
  COALESCE(m.fighter_b_id, fb.fighter_id) AS matched_fighter_b_id
FROM manual m
LEFT JOIN fighters fa ON m.fighter_a_norm = fa.fighter_name_norm
LEFT JOIN fighters fb ON m.fighter_b_norm = fb.fighter_name_norm
WHERE COALESCE(m.fighter_a_id, fa.fighter_id) IS NULL
   OR COALESCE(m.fighter_b_id, fb.fighter_id) IS NULL;
