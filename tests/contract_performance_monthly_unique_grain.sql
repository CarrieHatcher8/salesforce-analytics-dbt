select
    contract_id,
    reporting_month,
    count(*) as row_count

from {{ ref('fct_contract_performance_monthly') }}

group by
    contract_id,
    reporting_month

having count(*) > 1