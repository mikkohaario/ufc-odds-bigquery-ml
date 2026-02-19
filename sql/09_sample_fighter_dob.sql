SELECT fighter_name, dob_raw, dob
FROM `ufc-odds-ml.ufc_stg.stg_fighters`
WHERE dob_raw IS NOT NULL
LIMIT 10;