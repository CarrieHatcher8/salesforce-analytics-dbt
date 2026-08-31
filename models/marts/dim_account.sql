select
    account_id,
    account_name,
    industry,
    account_type,
    annual_revenue,
    created_at as account_created_date,
    modified_at as account_last_modified_date

from {{ ref('stg_salesforce__account') }}