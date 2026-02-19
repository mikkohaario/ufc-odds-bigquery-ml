SELECT
  processed_input,
  weight
FROM ML.WEIGHTS(MODEL `ufc-odds-ml.ufc_ml.rolling_lr`)
WHERE ARRAY_LENGTH(category_weights) = 0
ORDER BY ABS(weight) DESC
LIMIT 20;