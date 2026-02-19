CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.fights_rolling_model_ready` AS
WITH med AS (
  SELECT
    (SELECT APPROX_QUANTILES(r_win_rate_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE r_win_rate_before IS NOT NULL) AS r_win_rate_med,
    (SELECT APPROX_QUANTILES(b_win_rate_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE b_win_rate_before IS NOT NULL) AS b_win_rate_med,
    (SELECT APPROX_QUANTILES(r_sig_str_lpm_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE r_sig_str_lpm_before IS NOT NULL) AS r_sig_lpm_med,
    (SELECT APPROX_QUANTILES(b_sig_str_lpm_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE b_sig_str_lpm_before IS NOT NULL) AS b_sig_lpm_med,
    (SELECT APPROX_QUANTILES(r_td_lpm_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE r_td_lpm_before IS NOT NULL) AS r_td_lpm_med,
    (SELECT APPROX_QUANTILES(b_td_lpm_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE b_td_lpm_before IS NOT NULL) AS b_td_lpm_med,
    (SELECT APPROX_QUANTILES(r_ctrl_pm_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE r_ctrl_pm_before IS NOT NULL) AS r_ctrl_pm_med,
    (SELECT APPROX_QUANTILES(b_ctrl_pm_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE b_ctrl_pm_before IS NOT NULL) AS b_ctrl_pm_med
)
SELECT
  f.*,
  IFNULL(f.r_win_rate_before, med.r_win_rate_med) AS r_win_rate_imputed,
  IFNULL(f.b_win_rate_before, med.b_win_rate_med) AS b_win_rate_imputed,
  IFNULL(f.r_sig_str_lpm_before, med.r_sig_lpm_med) AS r_sig_str_lpm_imputed,
  IFNULL(f.b_sig_str_lpm_before, med.b_sig_lpm_med) AS b_sig_str_lpm_imputed,
  IFNULL(f.r_td_lpm_before, med.r_td_lpm_med) AS r_td_lpm_imputed,
  IFNULL(f.b_td_lpm_before, med.b_td_lpm_med) AS b_td_lpm_imputed,
  IFNULL(f.r_ctrl_pm_before, med.r_ctrl_pm_med) AS r_ctrl_pm_imputed,
  IFNULL(f.b_ctrl_pm_before, med.b_ctrl_pm_med) AS b_ctrl_pm_imputed,
  IF(f.r_fights_before = 0, 1, 0) AS r_no_hist,
  IF(f.b_fights_before = 0, 1, 0) AS b_no_hist
FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` f
CROSS JOIN med;