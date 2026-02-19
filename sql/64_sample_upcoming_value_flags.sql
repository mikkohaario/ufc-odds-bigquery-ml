SELECT
  event_date,
  fighter_a,
  fighter_b,
  odds_a,
  odds_b,
  model_prob_a,
  implied_prob_a,
  edge_a,
  value_flag_a,
  model_prob_b,
  implied_prob_b,
  edge_b,
  value_flag_b
FROM `ufc-odds-ml.ufc_ml.upcoming_value_flags`
ORDER BY edge_a DESC;