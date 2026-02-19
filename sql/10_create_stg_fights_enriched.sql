CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.stg_fights_enriched` AS
SELECT
  f.*,
  rf.fighter_name AS r_fighter_name,
  rf.dob AS r_dob,
  DATE_DIFF(f.event_date, rf.dob, YEAR) AS r_age,
  rf.height AS r_height,
  rf.weight AS r_weight,
  rf.reach AS r_reach,
  rf.stance AS r_stance,
  rf.wins AS r_wins,
  rf.losses AS r_losses,
  rf.draws AS r_draws,
  bf.fighter_name AS b_fighter_name,
  bf.dob AS b_dob,
  DATE_DIFF(f.event_date, bf.dob, YEAR) AS b_age,
  bf.height AS b_height,
  bf.weight AS b_weight,
  bf.reach AS b_reach,
  bf.stance AS b_stance,
  bf.wins AS b_wins,
  bf.losses AS b_losses,
  bf.draws AS b_draws
FROM `ufc-odds-ml.ufc_stg.stg_fights` f
LEFT JOIN `ufc-odds-ml.ufc_stg.stg_fighters` rf
  ON f.r_id = rf.fighter_id
LEFT JOIN `ufc-odds-ml.ufc_stg.stg_fighters` bf
  ON f.b_id = bf.fighter_id;