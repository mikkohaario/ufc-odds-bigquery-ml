SELECT *
FROM ML.EVALUATE(
  MODEL `ufc-odds-ml.ufc_ml.rolling_lr`,
  (
    SELECT
      r_win_label,
      division,
      title_fight,
      total_rounds,
      r_age_imputed,
      b_age_imputed,
      r_height_imputed,
      b_height_imputed,
      r_reach_imputed,
      b_reach_imputed,
      r_stance_imputed,
      b_stance_imputed,
      r_age_missing,
      b_age_missing,
      r_height_missing,
      b_height_missing,
      r_reach_missing,
      b_reach_missing,
      r_stance_missing,
      b_stance_missing,
      r_fights_before,
      b_fights_before,
      r_win_rate_imputed,
      b_win_rate_imputed,
      r_sig_str_lpm_imputed,
      b_sig_str_lpm_imputed,
      r_td_lpm_imputed,
      b_td_lpm_imputed,
      r_ctrl_pm_imputed,
      b_ctrl_pm_imputed,
      r_no_hist,
      b_no_hist
    FROM `ufc-odds-ml.ufc_stg.split_valid_rolling`
  )
);