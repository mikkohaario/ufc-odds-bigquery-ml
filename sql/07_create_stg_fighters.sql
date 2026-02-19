CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.stg_fighters` AS
SELECT
  id AS fighter_id,
  TRIM(name) AS fighter_name,
  NULLIF(TRIM(nick_name), '') AS nick_name,
  wins,
  losses,
  draws,
  height,
  weight,
  reach,
  LOWER(TRIM(stance)) AS stance,
  dob AS dob_raw,
  SAFE.PARSE_DATE('%B %d, %Y', dob) AS dob,
  splm,
  str_acc,
  sapm,
  str_def,
  td_avg,
  td_avg_acc,
  td_def,
  sub_avg
FROM `ufc-odds-ml.ufc_raw.fighter_details`;