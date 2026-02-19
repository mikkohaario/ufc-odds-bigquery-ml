CREATE OR REPLACE TABLE `ufc-odds-ml.ufc_ml.test_predictions_rolling_labeled` AS
SELECT
  p.*,
  t.r_win_label
FROM `ufc-odds-ml.ufc_ml.test_predictions_rolling` p
LEFT JOIN `ufc-odds-ml.ufc_stg.split_test_rolling` t
  USING (fight_id);