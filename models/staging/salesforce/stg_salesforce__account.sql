select
    id as account_id,
    name as account_name,
    industry,
    type as account_type,
    annual_revenue,
    created_date as created_at,
    last_modified_date as modified_at
from {{ source('salesforce', 'account') }}