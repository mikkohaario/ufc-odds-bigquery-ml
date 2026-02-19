SELECT
  r_win_label,
  COUNT(*) AS fights
FROM `ufc-odds-ml.ufc_stg.stg_fights_labeled`
GROUP BY r_win_label
ORDER BY r_win_label;