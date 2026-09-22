select
    enterprise_customer_key,
    salesforce_account_id,
    finance_customer_id
from {{ source('finance', 'customer_xref') }}