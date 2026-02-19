SELECT
  processed_input,
  weight
FROM ML.WEIGHTS(MODEL `ufc-odds-ml.ufc_ml.baseline_lr`)
WHERE ARRAY_LENGTH(category_weights) = 0
ORDER BY ABS(weight) DESC
LIMIT 15;