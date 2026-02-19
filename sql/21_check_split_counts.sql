SELECT
  'train' AS split, COUNT(*) AS row_count
FROM `ufc-odds-ml.ufc_stg.split_train`
UNION ALL
SELECT
  'valid' AS split, COUNT(*) AS row_count
FROM `ufc-odds-ml.ufc_stg.split_valid`
UNION ALL
SELECT
  'test' AS split, COUNT(*) AS row_count
FROM `ufc-odds-ml.ufc_stg.split_test`;