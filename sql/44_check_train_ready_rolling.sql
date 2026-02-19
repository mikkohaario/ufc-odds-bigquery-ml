SELECT
  COUNT(*) AS total,
  COUNTIF(r_win_label IS NULL) AS null_labels
FROM `ufc-odds-ml.ufc_stg.train_ready_rolling`;