# dbt_external_tables_athena

Additional macros to enable Athena support in dbt_external_tables.

See https://github.com/dbt-labs/dbt-external-tables/pull/133#issuecomment-1896479270 for details.

Version 0.0.2 adds support for LFTags configuration.

## Installation

Add to `packages.yml` in your project:

```yaml
packages:
   - package: dbt-labs/dbt_external_tables
     version: ['>=0.8.7']
   - git: https://github.com/rstml/dbt-external-tables-athena/
     revision: 0.0.2
```

Add the following to `dbt_project.yml` to override macro search order:

```yaml
dispatch:
  - macro_namespace: dbt_external_tables
    search_order: [dbt_external_tables_athena, dbt_external_tables]

# Optionally, stage the external tables when dbt starts run
on-run-start:
  - "{{ dbt_external_tables.stage_external_sources() }}"
```

Finally, here's an example for your project's `models/sources.yml`:

```yaml
version: 2

sources:
  - name: mydbt
    loader: "s3"
    quoting:
      database: false
      schema: false
      identifier: false
      column: true
    tables:
      - name: demo_transactions
        database: awscatalog
        external:
          location: 's3://my-lakehouse-demo/demo/transactions/'
          row_format: "SERDE 'org.openx.data.jsonserde.JsonSerDe'"
          lf_tags_config:
            enabled: true
            tags:
              'Group:Analyst': 'true'
              'Classification': 'Confidential'
        columns:
          - name: transaction_id
            data_type: int
            description: "Transaction ID (primary key)"
            tests:
              - unique
              - not_null
          - name: amount
            data_type: decimal(4, 2)
            tests:
              - not_null
          - name: currency
            data_type: varchar(3)
            tests:
              - not_null
          - name: payment_processor
            data_type: varchar(50)
          - name: timestamp
            data_type: timestamp
```
