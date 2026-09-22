select
    contract_id,
    finance_customer_id,
    salesforce_opportunity_id,
    contract_execution_date,
    contract_value,
    contract_status,
    booking_exception_reason

from {{ ref('int_finance__contract_validated') }}

where booking_record_status = 'QUARANTINED'