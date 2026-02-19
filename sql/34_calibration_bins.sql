WITH binned AS (
  SELECT
    CAST(FLOOR(prob_r_win * 10) AS INT64) AS bin,
    AVG(prob_r_win) AS avg_prob,
    AVG(CAST(r_win_label AS FLOAT64)) AS actual_rate,
    COUNT(*) AS n
  FROM (
    SELECT
      r_win_label,
      predicted_r_win_label_probs[OFFSET(1)].prob AS prob_r_win
    FROM `ufc-odds-ml.ufc_ml.test_predictions_labeled`
    WHERE r_win_label IS NOT NULL
  )
  GROUP BY bin
)
SELECT *
FROM binned
ORDER BY bin;