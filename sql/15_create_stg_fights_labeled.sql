CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.stg_fights_labeled` AS
SELECT
  f.*,
  CASE
    WHEN f.winner_id = f.r_id THEN 1
    WHEN f.winner_id = f.b_id THEN 0
    ELSE NULL
  END AS r_win_label,
  CASE
    WHEN f.winner_id IS NULL THEN 'unknown'
    WHEN f.winner_id = f.r_id THEN 'red'
    WHEN f.winner_id = f.b_id THEN 'blue'
    ELSE 'other'
  END AS winner_corner
FROM `ufc-odds-ml.ufc_stg.stg_fights_model_ready` f;