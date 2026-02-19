WITH fights AS (
  SELECT * FROM {{ ref('stg_fights') }}
),
fighters AS (
  SELECT * FROM {{ ref('stg_fighters') }}
)
SELECT
  f.*,
  r.fighter_name AS r_name,
  b.fighter_name AS b_name,
  DATE_DIFF(f.event_date, r.dob, YEAR) AS r_age,
  DATE_DIFF(f.event_date, b.dob, YEAR) AS b_age,
  r.height AS r_height,
  b.height AS b_height,
  r.reach AS r_reach,
  b.reach AS b_reach,
  r.stance AS r_stance,
  b.stance AS b_stance
FROM fights f
LEFT JOIN fighters r ON f.r_id = r.fighter_id
LEFT JOIN fighters b ON f.b_id = b.fighter_id
