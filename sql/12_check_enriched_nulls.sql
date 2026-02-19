SELECT
  COUNT(*) AS total,
  COUNTIF(r_age IS NULL) AS null_r_age,
  COUNTIF(b_age IS NULL) AS null_b_age,
  COUNTIF(r_reach IS NULL) AS null_r_reach,
  COUNTIF(b_reach IS NULL) AS null_b_reach,
  COUNTIF(r_stance IS NULL) AS null_r_stance,
  COUNTIF(b_stance IS NULL) AS null_b_stance
FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched`;