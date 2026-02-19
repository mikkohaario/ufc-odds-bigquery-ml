SELECT
  processed_input,
  cw.category,
  cw.weight
FROM ML.WEIGHTS(MODEL `ufc-odds-ml.ufc_ml.baseline_lr`),
UNNEST(category_weights) AS cw
ORDER BY ABS(cw.weight) DESC
LIMIT 25;