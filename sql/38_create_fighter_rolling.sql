CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.fighter_rolling` AS
SELECT
  *,
  COUNT(*) OVER w AS fights_before,
  AVG(win_label) OVER w AS win_rate_before,
  AVG(sig_str_lpm) OVER w AS sig_str_lpm_before,
  AVG(total_str_lpm) OVER w AS total_str_lpm_before,
  AVG(td_lpm) OVER w AS td_lpm_before,
  AVG(ctrl_pm) OVER w AS ctrl_pm_before,
  AVG(sub_att) OVER w AS sub_att_before,
  AVG(kd) OVER w AS kd_before,
  AVG(sig_str_acc) OVER w AS sig_str_acc_before,
  AVG(total_str_acc) OVER w AS total_str_acc_before,
  AVG(td_acc) OVER w AS td_acc_before
FROM `ufc-odds-ml.ufc_stg.fight_stats_long`
WINDOW w AS (
  PARTITION BY fighter_id
  ORDER BY event_date, fight_id
  ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
);