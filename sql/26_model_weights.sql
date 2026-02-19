SELECT *
FROM ML.WEIGHTS(MODEL `ufc-odds-ml.ufc_ml.baseline_lr`)
ORDER BY ABS(weight) DESC;