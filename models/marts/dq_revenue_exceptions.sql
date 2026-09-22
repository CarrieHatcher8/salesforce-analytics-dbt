select
    revenue_id,
    contract_id,
    accounting_period,
    recognized_revenue,
    recognized_at,
    revenue_record_status,
    revenue_exception_reason

from {{ ref('int_finance__revenue_validated') }}

where revenue_record_status = 'QUARANTINED'