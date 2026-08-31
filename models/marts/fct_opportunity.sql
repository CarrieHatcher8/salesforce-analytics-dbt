select
    opportunity_id,
    account_id,
    sales_rep_id,

    opportunity_name,
    opportunity_stage,
    opportunity_amount,
    opportunity_target_close_date,
    opportunity_is_closed,
    opportunity_is_won,

    opportunity_created_date,
    opportunity_last_modified_date

from {{ ref('int_salesforce__opportunity_enriched') }}