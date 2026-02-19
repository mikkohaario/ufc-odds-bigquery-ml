CREATE OR REPLACE TABLE `ufc-odds-ml.ufc_ml.test_predictions_labeled` AS
SELECT
  p.*,
  t.r_win_label
FROM `ufc-odds-ml.ufc_ml.test_predictions` p
LEFT JOIN `ufc-odds-ml.ufc_stg.split_test` t
  USING (fight_id);