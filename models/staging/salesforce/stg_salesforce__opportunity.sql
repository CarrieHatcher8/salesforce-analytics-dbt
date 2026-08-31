select
    id as opportunity_id,
    account_id,
    owner_id as sales_rep_id,
    name as opportunity_name,
    stage_name as opportunity_stage,
    amount as opportunity_amount,
    close_date as opportunity_target_close_date,
    is_closed as opportunity_is_closed,
    is_won as opportunity_is_won,
    created_date as opportunity_created_date,
    last_modified_date as opportunity_last_modified_date

from {{ source('salesforce', 'opportunity') }}