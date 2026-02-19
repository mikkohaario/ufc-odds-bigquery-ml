CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.model_features_safe` AS
SELECT
  fight_id,
  event_date,
  division,
  title_fight,
  total_rounds,
  r_age_imputed,
  b_age_imputed,
  r_height_imputed,
  b_height_imputed,
  r_reach_imputed,
  b_reach_imputed,
  r_stance_imputed,
  b_stance_imputed,
  r_age_missing,
  b_age_missing,
  r_height_missing,
  b_height_missing,
  r_reach_missing,
  b_reach_missing,
  r_stance_missing,
  b_stance_missing
FROM `ufc-odds-ml.ufc_stg.stg_fights_labeled`;