select
    sales_rep_id,
    sales_rep_name,
    sales_rep_email,
    sales_rep_is_active

from {{ ref('stg_salesforce__user') }}