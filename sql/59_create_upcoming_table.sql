CREATE OR REPLACE TABLE `ufc-odds-ml.ufc_ml.upcoming_fights_manual` (
  event_date DATE,
  event_name STRING,
  division STRING,
  total_rounds INT64,
  title_fight INT64,
  fighter_a STRING,
  fighter_b STRING,
  odds_a FLOAT64,
  odds_b FLOAT64,
  fighter_a_id STRING,
  fighter_b_id STRING
);