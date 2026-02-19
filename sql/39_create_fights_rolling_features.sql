CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.fights_rolling_features` AS
SELECT
  f.fight_id,
  f.event_date,
  f.division,
  f.title_fight,
  f.total_rounds,
  f.r_id,
  f.b_id,
  r.fights_before AS r_fights_before,
  b.fights_before AS b_fights_before,
  r.win_rate_before AS r_win_rate_before,
  b.win_rate_before AS b_win_rate_before,
  r.sig_str_lpm_before AS r_sig_str_lpm_before,
  b.sig_str_lpm_before AS b_sig_str_lpm_before,
  r.td_lpm_before AS r_td_lpm_before,
  b.td_lpm_before AS b_td_lpm_before,
  r.ctrl_pm_before AS r_ctrl_pm_before,
  b.ctrl_pm_before AS b_ctrl_pm_before,
  r.sub_att_before AS r_sub_att_before,
  b.sub_att_before AS b_sub_att_before,
  r.kd_before AS r_kd_before,
  b.kd_before AS b_kd_before,
  r.sig_str_acc_before AS r_sig_str_acc_before,
  b.sig_str_acc_before AS b_sig_str_acc_before,
  r.total_str_acc_before AS r_total_str_acc_before,
  b.total_str_acc_before AS b_total_str_acc_before,
  r.td_acc_before AS r_td_acc_before,
  b.td_acc_before AS b_td_acc_before,
  (r.win_rate_before - b.win_rate_before) AS win_rate_diff,
  (r.sig_str_lpm_before - b.sig_str_lpm_before) AS sig_str_lpm_diff,
  (r.td_lpm_before - b.td_lpm_before) AS td_lpm_diff,
  (r.ctrl_pm_before - b.ctrl_pm_before) AS ctrl_pm_diff
FROM `ufc-odds-ml.ufc_stg.stg_fights` f
LEFT JOIN `ufc-odds-ml.ufc_stg.fighter_rolling` r
  ON f.fight_id = r.fight_id AND r.corner = 'red'
LEFT JOIN `ufc-odds-ml.ufc_stg.fighter_rolling` b
  ON f.fight_id = b.fight_id AND b.corner = 'blue';