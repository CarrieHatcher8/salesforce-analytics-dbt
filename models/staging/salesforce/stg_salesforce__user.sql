select
    id as sales_rep_id,
    name as sales_rep_name,
    email as sales_rep_email,
    is_active as sales_rep_is_active

from {{ source('salesforce', 'user') }}