SELECT
  fight_id,
  event_date,
  match_time_sec,
  r_ctrl,
  b_ctrl,
  SAFE_DIVIDE(r_ctrl, match_time_sec / 60.0) AS r_ctrl_per_min,
  SAFE_DIVIDE(b_ctrl, match_time_sec / 60.0) AS b_ctrl_per_min
FROM `ufc-odds-ml.ufc_stg.stg_fights`
WHERE match_time_sec IS NOT NULL
ORDER BY event_date DESC
LIMIT 10;