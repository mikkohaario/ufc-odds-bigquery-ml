WITH src AS (
  SELECT * FROM {{ source('ufc_raw', 'fighter_details') }}
)
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
  SAFE.PARSE_DATE('%b %d, %Y', dob) AS dob
FROM src
