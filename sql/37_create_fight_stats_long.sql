CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.fight_stats_long` AS
WITH base AS (
  SELECT
    fight_id,
    event_date,
    event_id,
    division,
    title_fight,
    total_rounds,
    finish_round,
    match_time_sec,
    CASE
      WHEN finish_round IS NULL OR match_time_sec IS NULL THEN NULL
      ELSE (finish_round - 1) * 300 + match_time_sec
    END AS total_fight_sec,
    winner_id,
    r_id,
    b_id,
    -- red side
    r_kd AS kd,
    r_sig_str_landed AS sig_str_landed,
    r_sig_str_atmpted AS sig_str_attempted,
    r_total_str_landed AS total_str_landed,
    r_total_str_atmpted AS total_str_attempted,
    r_td_landed AS td_landed,
    r_td_atmpted AS td_attempted,
    r_sub_att AS sub_att,
    r_ctrl AS ctrl,
    r_head_landed AS head_landed,
    r_head_atmpted AS head_attempted,
    r_body_landed AS body_landed,
    r_body_atmpted AS body_attempted,
    r_leg_landed AS leg_landed,
    r_leg_atmpted AS leg_attempted,
    r_clinch_landed AS clinch_landed,
    r_clinch_atmpted AS clinch_attempted,
    r_ground_landed AS ground_landed,
    r_ground_atmpted AS ground_attempted,
    r_dist_landed AS dist_landed,
    r_dist_atmpted AS dist_attempted,
    'red' AS corner
  FROM `ufc-odds-ml.ufc_stg.stg_fights`

  UNION ALL

  SELECT
    fight_id,
    event_date,
    event_id,
    division,
    title_fight,
    total_rounds,
    finish_round,
    match_time_sec,
    CASE
      WHEN finish_round IS NULL OR match_time_sec IS NULL THEN NULL
      ELSE (finish_round - 1) * 300 + match_time_sec
    END AS total_fight_sec,
    winner_id,
    b_id AS r_id,
    r_id AS b_id,
    -- blue side (mapped to same columns)
    b_kd AS kd,
    b_sig_str_landed AS sig_str_landed,
    b_sig_str_atmpted AS sig_str_attempted,
    b_total_str_landed AS total_str_landed,
    b_total_str_atmpted AS total_str_attempted,
    b_td_landed AS td_landed,
    b_td_atmpted AS td_attempted,
    b_sub_att AS sub_att,
    b_ctrl AS ctrl,
    b_head_landed AS head_landed,
    b_head_atmpted AS head_attempted,
    b_body_landed AS body_landed,
    b_body_atmpted AS body_attempted,
    b_leg_landed AS leg_landed,
    b_leg_atmpted AS leg_attempted,
    b_clinch_landed AS clinch_landed,
    b_clinch_atmpted AS clinch_attempted,
    b_ground_landed AS ground_landed,
    b_ground_atmpted AS ground_attempted,
    b_dist_landed AS dist_landed,
    b_dist_atmpted AS dist_attempted,
    'blue' AS corner
  FROM `ufc-odds-ml.ufc_stg.stg_fights`
),
final AS (
  SELECT
    fight_id,
    event_date,
    event_id,
    division,
    title_fight,
    total_rounds,
    finish_round,
    match_time_sec,
    total_fight_sec,
    r_id AS fighter_id,
    b_id AS opponent_id,
    corner,
    CASE
      WHEN winner_id = r_id THEN 1
      WHEN winner_id = b_id THEN 0
      ELSE NULL
    END AS win_label,
    kd,
    sig_str_landed,
    sig_str_attempted,
    total_str_landed,
    total_str_attempted,
    td_landed,
    td_attempted,
    sub_att,
    ctrl,
    head_landed,
    head_attempted,
    body_landed,
    body_attempted,
    leg_landed,
    leg_attempted,
    clinch_landed,
    clinch_attempted,
    ground_landed,
    ground_attempted,
    dist_landed,
    dist_attempted,
    SAFE_DIVIDE(sig_str_landed, sig_str_attempted) AS sig_str_acc,
    SAFE_DIVIDE(total_str_landed, total_str_attempted) AS total_str_acc,
    SAFE_DIVIDE(td_landed, td_attempted) AS td_acc,
    SAFE_DIVIDE(sig_str_landed, total_fight_sec / 60.0) AS sig_str_lpm,
    SAFE_DIVIDE(total_str_landed, total_fight_sec / 60.0) AS total_str_lpm,
    SAFE_DIVIDE(td_landed, total_fight_sec / 60.0) AS td_lpm,
    SAFE_DIVIDE(ctrl, total_fight_sec / 60.0) AS ctrl_pm
  FROM base
)
SELECT * FROM final;