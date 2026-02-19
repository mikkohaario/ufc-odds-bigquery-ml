SELECT
  COUNT(*) AS total_rows,
  COUNTIF(event_date IS NULL) AS null_event_date
FROM `ufc-odds-ml.ufc_stg.stg_fights`;