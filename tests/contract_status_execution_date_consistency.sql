
{{ config(severity='warn') }}

select
    contract_id,
    contract_status,
    contract_execution_date

from {{ ref('stg_finance__contract') }}

where
    (contract_status = 'EXECUTED' and contract_execution_date is null)

    or

    (contract_status = 'PENDING' and contract_execution_date is not null)