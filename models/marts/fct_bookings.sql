select
    contract_id,
    finance_customer_id,
    salesforce_opportunity_id,
    contract_execution_date as booking_date,
    contract_value as booking_amount

from {{ ref('int_finance__contract_validated') }}

where booking_record_status = 'BOOKING_ELIGIBLE'