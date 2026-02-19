SELECT
  'train' AS split, COUNT(*) AS row_count
FROM `ufc-odds-ml.ufc_stg.split_train_rolling`
UNION ALL
SELECT
  'valid' AS split, COUNT(*) AS row_count
FROM `ufc-odds-ml.ufc_stg.split_valid_rolling`
UNION ALL
SELECT
  'test' AS split, COUNT(*) AS row_count
FROM `ufc-odds-ml.ufc_stg.split_test_rolling`;