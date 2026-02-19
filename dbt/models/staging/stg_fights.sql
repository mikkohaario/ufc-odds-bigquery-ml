WITH fights AS (
  SELECT * FROM {{ source('ufc_raw', 'fight_details') }}
),
events AS (
  SELECT * FROM {{ source('ufc_raw', 'event_details') }}
)
SELECT
  f.*,
  e.date AS event_date_raw,
  SAFE.PARSE_DATE('%B %d, %Y', e.date) AS event_date,
  e.location AS event_location,
  e.winner,
  e.winner_id
FROM fights f
LEFT JOIN events e
  ON f.fight_id = e.fight_id
