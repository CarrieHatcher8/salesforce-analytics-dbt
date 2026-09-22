select
    contract_id,
    finance_customer_id,
    salesforce_opportunity_id,
    contract_execution_date,
    contract_value,
    contract_status,
    created_at
from {{ source('finance', 'contract') }}