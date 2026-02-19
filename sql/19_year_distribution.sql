SELECT EXTRACT(YEAR FROM event_date) AS year, COUNT(*) AS fights
FROM `ufc-odds-ml.ufc_stg.train_ready_safe`
GROUP BY year
ORDER BY year;