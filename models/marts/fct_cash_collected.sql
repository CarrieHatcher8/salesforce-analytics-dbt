select
    receipt_id,
    contract_id,
    receipt_date,
    cash_amount,
    payment_method,
    created_at

from {{ ref('stg_finance__cash_receipt') }}