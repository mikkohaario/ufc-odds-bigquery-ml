SELECT
  fight_id,
  event_date,
  predicted_r_win_label,
  predicted_r_win_label_probs[OFFSET(1)].prob AS prob_r_win
FROM `ufc-odds-ml.ufc_ml.test_predictions`
LIMIT 10;