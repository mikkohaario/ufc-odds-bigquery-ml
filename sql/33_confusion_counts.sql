SELECT
  predicted_r_win_label,
  r_win_label,
  COUNT(*) AS n
FROM `ufc-odds-ml.ufc_ml.test_predictions_labeled`
GROUP BY predicted_r_win_label, r_win_label
ORDER BY predicted_r_win_label, r_win_label;