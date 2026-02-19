SELECT
  COUNT(*) AS total,
  COUNTIF(dob IS NULL) AS null_dob,
  COUNTIF(stance IS NULL) AS null_stance,
  COUNTIF(height IS NULL) AS null_height,
  COUNTIF(reach IS NULL) AS null_reach
FROM `ufc-odds-ml.ufc_stg.stg_fighters`;