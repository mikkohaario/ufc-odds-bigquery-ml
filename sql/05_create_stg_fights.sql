CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.stg_fights` AS
SELECT
  f.*,
  e.date AS event_date_raw,
  SAFE.PARSE_DATE('%B %d, %Y', e.date) AS event_date,
  e.location AS event_location,
  e.winner,
  e.winner_id
FROM `ufc-odds-ml.ufc_raw.fight_details` f
LEFT JOIN `ufc-odds-ml.ufc_raw.event_details` e
  ON f.fight_id = e.fight_id;