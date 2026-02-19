CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.train_ready_rolling` AS
SELECT
  s.fight_id,
  s.event_date,
  s.division,
  s.title_fight,
  s.total_rounds,
  -- safe features
  s.r_age_imputed,
  s.b_age_imputed,
  s.r_height_imputed,
  s.b_height_imputed,
  s.r_reach_imputed,
  s.b_reach_imputed,
  s.r_stance_imputed,
  s.b_stance_imputed,
  s.r_age_missing,
  s.b_age_missing,
  s.r_height_missing,
  s.b_height_missing,
  s.r_reach_missing,
  s.b_reach_missing,
  s.r_stance_missing,
  s.b_stance_missing,
  -- rolling features
  r.r_fights_before,
  r.b_fights_before,
  r.r_win_rate_imputed,
  r.b_win_rate_imputed,
  r.r_sig_str_lpm_imputed,
  r.b_sig_str_lpm_imputed,
  r.r_td_lpm_imputed,
  r.b_td_lpm_imputed,
  r.r_ctrl_pm_imputed,
  r.b_ctrl_pm_imputed,
  r.r_no_hist,
  r.b_no_hist,
  s.r_win_label
FROM `ufc-odds-ml.ufc_stg.stg_fights_labeled` s
LEFT JOIN `ufc-odds-ml.ufc_stg.fights_rolling_model_ready` r
  USING (fight_id);