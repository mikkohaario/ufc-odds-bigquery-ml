SELECT
  column_name,
  data_type
FROM `ufc-odds-ml.ufc_raw.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = "event_details"
ORDER BY ordinal_position;