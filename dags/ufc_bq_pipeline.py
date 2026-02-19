from __future__ import annotations

from datetime import datetime
from pathlib import Path

from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator

SQL_DIR = Path(__file__).resolve().parents[1] / "sql"

BASELINE_SQL = [
    "07_create_stg_fighters.sql",
    "10_create_stg_fights_enriched.sql",
    "13_create_stg_fights_model_ready.sql",
    "15_create_stg_fights_labeled.sql",
    "17_create_model_features_safe.sql",
    "18_create_train_view_safe.sql",
    "20_create_time_split.sql",
    "23_create_baseline_lr.sql",
    "24_eval_valid.sql",
    "25_eval_test.sql",
]

ROLLING_SQL = [
    "37_create_fight_stats_long.sql",
    "38_create_fighter_rolling.sql",
    "39_create_fights_rolling_features.sql",
    "42_create_fights_rolling_model_ready.sql",
    "45_create_train_ready_rolling_labeled.sql",
    "46_create_time_split_rolling.sql",
    "48_create_rolling_lr.sql",
    "49_eval_valid_rolling.sql",
    "50_eval_test_rolling.sql",
]


def load_sql(filename: str) -> str:
    return (SQL_DIR / filename).read_text(encoding="utf-8")


with DAG(
    dag_id="ufc_bq_pipeline",
    description="BQML baseline + rolling model pipeline (portfolio stub).",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
    tags=["ufc", "bigquery", "bqml"],
) as dag:
    prev = None

    for fname in BASELINE_SQL + ROLLING_SQL:
        task = BigQueryInsertJobOperator(
            task_id=f"run_{fname.replace('.sql', '')}",
            gcp_conn_id="google_cloud_default",
            location="EU",
            configuration={
                "query": {
                    "query": load_sql(fname),
                    "useLegacySql": False,
                }
            },
        )

        if prev:
            prev >> task
        prev = task
