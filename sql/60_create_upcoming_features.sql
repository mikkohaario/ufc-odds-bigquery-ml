CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_ml.upcoming_features` AS
WITH upcoming AS (
  SELECT
    *,
    TO_HEX(MD5(CONCAT(CAST(event_date AS STRING), '|', fighter_a, '|', fighter_b))) AS upcoming_id,
    REGEXP_REPLACE(LOWER(fighter_a), r'[^a-z0-9]', '') AS fighter_a_norm,
    REGEXP_REPLACE(LOWER(fighter_b), r'[^a-z0-9]', '') AS fighter_b_norm
  FROM (
    SELECT DISTINCT * FROM `ufc-odds-ml.ufc_ml.upcoming_fights_manual`
  )
),
fighters AS (
  SELECT
    fighter_id,
    fighter_name,
    REGEXP_REPLACE(LOWER(fighter_name), r'[^a-z0-9]', '') AS fighter_name_norm,
    dob,
    height,
    weight,
    reach,
    stance
  FROM `ufc-odds-ml.ufc_stg.stg_fighters`
),
match_ids AS (
  SELECT
    u.*,
    COALESCE(u.fighter_a_id, fa_name.fighter_id) AS fighter_a_id_final,
    COALESCE(u.fighter_b_id, fb_name.fighter_id) AS fighter_b_id_final
  FROM upcoming u
  LEFT JOIN fighters fa_name
    ON u.fighter_a_id IS NULL AND u.fighter_a_norm = fa_name.fighter_name_norm
  LEFT JOIN fighters fb_name
    ON u.fighter_b_id IS NULL AND u.fighter_b_norm = fb_name.fighter_name_norm
),
attrs AS (
  SELECT
    m.*,
    fa.fighter_name AS fighter_a_name_matched,
    fb.fighter_name AS fighter_b_name_matched,
    fa.dob AS fighter_a_dob,
    fb.dob AS fighter_b_dob,
    fa.height AS fighter_a_height,
    fb.height AS fighter_b_height,
    fa.reach AS fighter_a_reach,
    fb.reach AS fighter_b_reach,
    LOWER(TRIM(fa.stance)) AS fighter_a_stance,
    LOWER(TRIM(fb.stance)) AS fighter_b_stance
  FROM match_ids m
  LEFT JOIN fighters fa ON m.fighter_a_id_final = fa.fighter_id
  LEFT JOIN fighters fb ON m.fighter_b_id_final = fb.fighter_id
),
-- rolling aggregates for fighter A
hist_a AS (
  SELECT
    a.upcoming_id,
    COUNT(f.fight_id) AS r_fights_before,
    AVG(f.win_label) AS r_win_rate_before,
    AVG(f.sig_str_lpm) AS r_sig_str_lpm_before,
    AVG(f.td_lpm) AS r_td_lpm_before,
    AVG(f.ctrl_pm) AS r_ctrl_pm_before
  FROM attrs a
  LEFT JOIN `ufc-odds-ml.ufc_stg.fight_stats_long` f
    ON f.fighter_id = a.fighter_a_id_final
   AND f.event_date < a.event_date
  GROUP BY a.upcoming_id
),
-- rolling aggregates for fighter B
hist_b AS (
  SELECT
    a.upcoming_id,
    COUNT(f.fight_id) AS b_fights_before,
    AVG(f.win_label) AS b_win_rate_before,
    AVG(f.sig_str_lpm) AS b_sig_str_lpm_before,
    AVG(f.td_lpm) AS b_td_lpm_before,
    AVG(f.ctrl_pm) AS b_ctrl_pm_before
  FROM attrs a
  LEFT JOIN `ufc-odds-ml.ufc_stg.fight_stats_long` f
    ON f.fighter_id = a.fighter_b_id_final
   AND f.event_date < a.event_date
  GROUP BY a.upcoming_id
),
med_safe AS (
  SELECT
    (SELECT APPROX_QUANTILES(r_age, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched` WHERE r_age IS NOT NULL) AS r_age_med,
    (SELECT APPROX_QUANTILES(b_age, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched` WHERE b_age IS NOT NULL) AS b_age_med,
    (SELECT APPROX_QUANTILES(r_reach, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched` WHERE r_reach IS NOT NULL) AS r_reach_med,
    (SELECT APPROX_QUANTILES(b_reach, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched` WHERE b_reach IS NOT NULL) AS b_reach_med,
    (SELECT APPROX_QUANTILES(r_height, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched` WHERE r_height IS NOT NULL) AS r_height_med,
    (SELECT APPROX_QUANTILES(b_height, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.stg_fights_enriched` WHERE b_height IS NOT NULL) AS b_height_med
),
med_roll AS (
  SELECT
    (SELECT APPROX_QUANTILES(r_win_rate_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE r_win_rate_before IS NOT NULL) AS r_win_rate_med,
    (SELECT APPROX_QUANTILES(b_win_rate_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE b_win_rate_before IS NOT NULL) AS b_win_rate_med,
    (SELECT APPROX_QUANTILES(r_sig_str_lpm_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE r_sig_str_lpm_before IS NOT NULL) AS r_sig_lpm_med,
    (SELECT APPROX_QUANTILES(b_sig_str_lpm_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE b_sig_str_lpm_before IS NOT NULL) AS b_sig_lpm_med,
    (SELECT APPROX_QUANTILES(r_td_lpm_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE r_td_lpm_before IS NOT NULL) AS r_td_lpm_med,
    (SELECT APPROX_QUANTILES(b_td_lpm_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE b_td_lpm_before IS NOT NULL) AS b_td_lpm_med,
    (SELECT APPROX_QUANTILES(r_ctrl_pm_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE r_ctrl_pm_before IS NOT NULL) AS r_ctrl_pm_med,
    (SELECT APPROX_QUANTILES(b_ctrl_pm_before, 100)[OFFSET(50)] FROM `ufc-odds-ml.ufc_stg.fights_rolling_features` WHERE b_ctrl_pm_before IS NOT NULL) AS b_ctrl_pm_med
)
SELECT
  a.upcoming_id,
  a.event_date,
  a.event_name,
  a.division,
  a.title_fight,
  a.total_rounds,
  a.fighter_a,
  a.fighter_b,
  a.odds_a,
  a.odds_b,
  a.fighter_a_id_final AS r_id,
  a.fighter_b_id_final AS b_id,
  DATE_DIFF(a.event_date, a.fighter_a_dob, YEAR) AS r_age,
  DATE_DIFF(a.event_date, a.fighter_b_dob, YEAR) AS b_age,
  a.fighter_a_height AS r_height,
  a.fighter_b_height AS b_height,
  a.fighter_a_reach AS r_reach,
  a.fighter_b_reach AS b_reach,
  a.fighter_a_stance AS r_stance,
  a.fighter_b_stance AS b_stance,
  -- rolling raw
  ha.r_fights_before,
  hb.b_fights_before,
  ha.r_win_rate_before,
  hb.b_win_rate_before,
  ha.r_sig_str_lpm_before,
  hb.b_sig_str_lpm_before,
  ha.r_td_lpm_before,
  hb.b_td_lpm_before,
  ha.r_ctrl_pm_before,
  hb.b_ctrl_pm_before,
  -- imputed safe
  IFNULL(DATE_DIFF(a.event_date, a.fighter_a_dob, YEAR), med_safe.r_age_med) AS r_age_imputed,
  IFNULL(DATE_DIFF(a.event_date, a.fighter_b_dob, YEAR), med_safe.b_age_med) AS b_age_imputed,
  IFNULL(a.fighter_a_height, med_safe.r_height_med) AS r_height_imputed,
  IFNULL(a.fighter_b_height, med_safe.b_height_med) AS b_height_imputed,
  IFNULL(a.fighter_a_reach, med_safe.r_reach_med) AS r_reach_imputed,
  IFNULL(a.fighter_b_reach, med_safe.b_reach_med) AS b_reach_imputed,
  IFNULL(a.fighter_a_stance, 'unknown') AS r_stance_imputed,
  IFNULL(a.fighter_b_stance, 'unknown') AS b_stance_imputed,
  IF(DATE_DIFF(a.event_date, a.fighter_a_dob, YEAR) IS NULL, 1, 0) AS r_age_missing,
  IF(DATE_DIFF(a.event_date, a.fighter_b_dob, YEAR) IS NULL, 1, 0) AS b_age_missing,
  IF(a.fighter_a_height IS NULL, 1, 0) AS r_height_missing,
  IF(a.fighter_b_height IS NULL, 1, 0) AS b_height_missing,
  IF(a.fighter_a_reach IS NULL, 1, 0) AS r_reach_missing,
  IF(a.fighter_b_reach IS NULL, 1, 0) AS b_reach_missing,
  IF(a.fighter_a_stance IS NULL, 1, 0) AS r_stance_missing,
  IF(a.fighter_b_stance IS NULL, 1, 0) AS b_stance_missing,
  -- imputed rolling
  IFNULL(ha.r_fights_before, 0) AS r_fights_before_imputed,
  IFNULL(hb.b_fights_before, 0) AS b_fights_before_imputed,
  IFNULL(ha.r_win_rate_before, med_roll.r_win_rate_med) AS r_win_rate_imputed,
  IFNULL(hb.b_win_rate_before, med_roll.b_win_rate_med) AS b_win_rate_imputed,
  IFNULL(ha.r_sig_str_lpm_before, med_roll.r_sig_lpm_med) AS r_sig_str_lpm_imputed,
  IFNULL(hb.b_sig_str_lpm_before, med_roll.b_sig_lpm_med) AS b_sig_str_lpm_imputed,
  IFNULL(ha.r_td_lpm_before, med_roll.r_td_lpm_med) AS r_td_lpm_imputed,
  IFNULL(hb.b_td_lpm_before, med_roll.b_td_lpm_med) AS b_td_lpm_imputed,
  IFNULL(ha.r_ctrl_pm_before, med_roll.r_ctrl_pm_med) AS r_ctrl_pm_imputed,
  IFNULL(hb.b_ctrl_pm_before, med_roll.b_ctrl_pm_med) AS b_ctrl_pm_imputed,
  IF(IFNULL(ha.r_fights_before, 0) = 0, 1, 0) AS r_no_hist,
  IF(IFNULL(hb.b_fights_before, 0) = 0, 1, 0) AS b_no_hist
FROM attrs a
LEFT JOIN hist_a ha ON a.upcoming_id = ha.upcoming_id
LEFT JOIN hist_b hb ON a.upcoming_id = hb.upcoming_id
CROSS JOIN med_safe
CROSS JOIN med_roll;
