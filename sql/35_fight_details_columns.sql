SELECT
  column_name,
  data_type
FROM `ufc-odds-ml.ufc_raw.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = "fight_details"
  AND (
    STARTS_WITH(column_name, "r_")
    OR STARTS_WITH(column_name, "b_")
    OR column_name IN ("fight_id", "match_time_sec", "total_rounds", "title_fight", "division")
  )
ORDER BY column_name;