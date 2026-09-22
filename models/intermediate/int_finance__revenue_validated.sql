select
    r.revenue_id,
    r.contract_id,
    r.accounting_period,
    r.recognized_revenue,
    r.recognized_at,

    case
        when c.contract_id is not null
            then 'RECONCILED'
        else 'QUARANTINED'
    end as revenue_record_status,

    case
        when c.contract_id is null
            then 'CONTRACT_NOT_FOUND'
        else null
    end as revenue_exception_reason

from {{ ref('stg_finance__revenue') }} r

left join {{ ref('stg_finance__contract') }} c
    on r.contract_id = c.contract_id