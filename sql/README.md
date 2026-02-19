# SQL index

This folder contains numbered queries to reproduce the pipeline in BigQuery (Standard SQL).

## Core runs (in order)
- 01–21: data checks + staging
- 22–34: baseline BQML model + eval
- 35–58: rolling features + rolling model + eval
- 59–64: upcoming fight predictions + value flags

## Optional diagnostics
Files with `_check_` or `_sample_` are optional sanity checks and previews.
Most files use `CREATE OR REPLACE`, so reruns are safe.
