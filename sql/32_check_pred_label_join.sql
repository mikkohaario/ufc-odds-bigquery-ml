SELECT
  COUNT(*) AS total,
  COUNTIF(r_win_label IS NULL) AS null_labels
FROM `ufc-odds-ml.ufc_ml.test_predictions_labeled`;