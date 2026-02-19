SELECT
  fight_id,
  event_date,
  r_name, b_name,
  r_age, b_age,
  r_reach, b_reach,
  r_stance, b_stance
FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched`
LIMIT 5;