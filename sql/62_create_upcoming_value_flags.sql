CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_ml.upcoming_value_flags` AS
SELECT
  upcoming_id,
  event_date,
  event_name,
  division,
  fighter_a,
  fighter_b,
  odds_a,
  odds_b,
  predicted_r_win_label_probs[OFFSET(1)].prob AS model_prob_a,
  predicted_r_win_label_probs[OFFSET(0)].prob AS model_prob_b,
  SAFE_DIVIDE(1.0, odds_a) AS implied_prob_a,
  SAFE_DIVIDE(1.0, odds_b) AS implied_prob_b,
  predicted_r_win_label_probs[OFFSET(1)].prob - SAFE_DIVIDE(1.0, odds_a) AS edge_a,
  predicted_r_win_label_probs[OFFSET(0)].prob - SAFE_DIVIDE(1.0, odds_b) AS edge_b,
  CASE WHEN predicted_r_win_label_probs[OFFSET(1)].prob - SAFE_DIVIDE(1.0, odds_a) >= 0.05 THEN 1 ELSE 0 END AS value_flag_a,
  CASE WHEN predicted_r_win_label_probs[OFFSET(0)].prob - SAFE_DIVIDE(1.0, odds_b) >= 0.05 THEN 1 ELSE 0 END AS value_flag_b
FROM `ufc-odds-ml.ufc_ml.upcoming_predictions`;