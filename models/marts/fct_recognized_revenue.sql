select
    revenue_id,
    contract_id,
    accounting_period,
    recognized_revenue,
    recognized_at

from {{ ref('int_finance__revenue_validated') }}

where revenue_record_status = 'RECONCILED'