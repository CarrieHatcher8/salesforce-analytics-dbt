select
    receipt_id,
    contract_id,
    receipt_date,
    cash_amount,
    payment_method,
    created_at

from {{ source('finance', 'cash_receipt') }}