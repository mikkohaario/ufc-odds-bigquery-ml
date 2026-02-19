# dbt stub

This project ships a minimal dbt skeleton to showcase modeling structure.

## How to run (example)
1) Create a dbt profile in `~/.dbt/profiles.yml` (see `profiles.example.yml`).
2) From `dbt/`, run:

```
dbt debug
dbt run
dbt test
```

Models are configured as views by default.
