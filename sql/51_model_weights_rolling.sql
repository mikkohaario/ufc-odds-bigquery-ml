SELECT *
FROM ML.WEIGHTS(MODEL `ufc-odds-ml.ufc_ml.rolling_lr`)
ORDER BY ABS(weight) DESC;