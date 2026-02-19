SELECT
  r_age, r_age_imputed, r_age_missing,
  r_reach, r_reach_imputed, r_reach_missing,
  r_stance, r_stance_imputed, r_stance_missing
FROM `ufc-odds-ml.ufc_stg.stg_fights_model_ready`
LIMIT 5;