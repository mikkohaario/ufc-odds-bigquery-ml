CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.train_ready_rolling_labeled` AS
SELECT *
FROM `ufc-odds-ml.ufc_stg.train_ready_rolling`
WHERE r_win_label IS NOT NULL;