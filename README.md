# Salesforce Analytics Engineering Project

A portfolio project demonstrating an enterprise-style analytics architecture using **Snowflake and dbt Core**.

The project models Salesforce Account, Opportunity, and User data through governed staging, intermediate, and analytics mart layers. It demonstrates dimensional modeling, data quality testing, referential integrity, lineage, documentation, and separation of responsibilities across an analytics platform.

> **Note:** This project uses synthetic Salesforce-style data created specifically for demonstration purposes. It contains no proprietary or production company data.

## Architecture

The project follows a layered analytics architecture:

```text
RAW / Salesforce
       ↓
    STAGING
       ↓
  INTERMEDIATE
       ↓
     MARTS
```

### Data Flow

- **RAW** — Salesforce-style source data representing data landed by an ingestion platform such as Fivetran.
- **STAGING** — Standardizes source field names and establishes consistent analytics-friendly conventions.
- **INTERMEDIATE** — Combines Account, Opportunity, and User data for reusable business logic.
- **MARTS** — Provides governed fact and dimension models intended for BI and analytics consumption.

## dbt Lineage

![dbt lineage](docs/images/dbt_lineage.png)

The lineage is managed through dbt `source()` and `ref()` dependencies, allowing downstream impact and model relationships to be understood directly from the project DAG.

## Models

### Staging

- `stg_salesforce__account`
- `stg_salesforce__opportunity`
- `stg_salesforce__user`

### Intermediate

- `int_salesforce__opportunity_enriched`

### Marts

- `dim_account`
- `dim_sales_rep`
- `fct_opportunity`

The fact table is modeled at **one row per Salesforce Opportunity**.

Each opportunity is associated with an Account and a Sales Representative, with referential integrity enforced through dbt tests.

## Data Quality & Governance

The project includes automated dbt tests covering:

- Primary-key uniqueness
- Required-field / `not_null` validation
- Accepted Salesforce Opportunity stage values
- Accepted active/inactive User values
- Opportunity-to-Account referential integrity
- Opportunity-to-Sales-Representative referential integrity
- Fact-to-dimension relationships

The current project executes **24 automated data tests** as part of a full `dbt build`.

A successful build validates the models and their associated data-quality rules before downstream consumption.

## Snowflake Architecture

The Snowflake analytics database separates transformations into dedicated schemas:

```text
ANALYTICS
├── STAGING
│   ├── STG_SALESFORCE__ACCOUNT
│   ├── STG_SALESFORCE__OPPORTUNITY
│   └── STG_SALESFORCE__USER
│
├── INTERMEDIATE
│   └── INT_SALESFORCE__OPPORTUNITY_ENRICHED
│
└── MARTS
    ├── DIM_ACCOUNT
    ├── DIM_SALES_REP
    └── FCT_OPPORTUNITY
```

The architecture is designed around least-privilege access:

- Ingestion processes manage the RAW landing layer.
- dbt reads RAW data and builds governed analytics models.
- BI consumers access curated MARTS rather than source/raw tables.

This separation reduces the risk of inconsistent metric logic and limits unnecessary access to source data.

## Technology

- Snowflake
- dbt Core
- SQL
- YAML
- Git / GitHub
- Visual Studio Code
- PowerShell
- Python virtual environment

## dbt Commands

Common project commands include:

```bash
dbt parse
dbt run
dbt test
dbt build
dbt docs generate
dbt docs serve
```

## Design Principles

This project emphasizes:

- Clear source-to-consumption lineage
- Reusable transformation logic
- Consistent naming conventions
- Dimensional modeling
- Automated data-quality validation
- Referential integrity
- Separation of ingestion, transformation, and consumption responsibilities
- Least-privilege access
- Maintainability and downstream impact visibility