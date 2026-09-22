select
    revenue_id,
    contract_id,
    accounting_period,
    recognized_revenue,
    recognized_at

from {{ source('finance', 'revenue') }}