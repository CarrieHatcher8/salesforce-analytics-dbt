select
    contract_id,
    finance_customer_id,
    salesforce_opportunity_id,
    contract_execution_date,
    contract_value,
    contract_status,
    created_at,

    case
        when contract_status = 'EXECUTED'
             and contract_execution_date is not null
            then 'BOOKING_ELIGIBLE'

        when contract_status = 'PENDING'
             and contract_execution_date is null
            then 'NOT_YET_BOOKED'

        else 'QUARANTINED'
    end as booking_record_status,

    case
        when contract_status = 'PENDING'
             and contract_execution_date is not null
            then 'PENDING_CONTRACT_HAS_EXECUTION_DATE'

        when contract_status = 'EXECUTED'
             and contract_execution_date is null
            then 'EXECUTED_CONTRACT_MISSING_EXECUTION_DATE'

        else null
    end as booking_exception_reason

from {{ ref('stg_finance__contract') }}