SELECT
  COUNT(*) AS total,
  COUNTIF(r_fights_before = 0) AS r_zero_hist,
  COUNTIF(b_fights_before = 0) AS b_zero_hist,
  COUNTIF(r_win_rate_before IS NULL) AS r_win_rate_null,
  COUNTIF(b_win_rate_before IS NULL) AS b_win_rate_null
FROM `ufc-odds-ml.ufc_stg.fights_rolling_features`;