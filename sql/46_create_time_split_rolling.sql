CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.split_train_rolling` AS
SELECT *
FROM `ufc-odds-ml.ufc_stg.train_ready_rolling_labeled`
WHERE event_date <= DATE '2021-12-31';

CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.split_valid_rolling` AS
SELECT *
FROM `ufc-odds-ml.ufc_stg.train_ready_rolling_labeled`
WHERE event_date BETWEEN DATE '2022-01-01' AND DATE '2023-12-31';

CREATE OR REPLACE VIEW `ufc-odds-ml.ufc_stg.split_test_rolling` AS
SELECT *
FROM `ufc-odds-ml.ufc_stg.train_ready_rolling_labeled`
WHERE event_date >= DATE '2024-01-01';