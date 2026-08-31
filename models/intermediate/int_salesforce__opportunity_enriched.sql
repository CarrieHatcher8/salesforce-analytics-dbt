select
    o.opportunity_id,
    o.opportunity_name,
    o.opportunity_stage,
    o.opportunity_amount,
    o.opportunity_target_close_date,
    o.opportunity_is_closed,
    o.opportunity_is_won,
    o.opportunity_created_date,
    o.opportunity_last_modified_date,

    o.account_id,
    a.account_name,
    a.industry,
    a.account_type,
    a.annual_revenue,

    o.sales_rep_id,
    u.sales_rep_name,
    u.sales_rep_email,
    u.sales_rep_is_active

from {{ ref('stg_salesforce__opportunity') }} o

left join {{ ref('stg_salesforce__account') }} a
    on o.account_id = a.account_id

left join {{ ref('stg_salesforce__user') }} u
    on o.sales_rep_id = u.sales_rep_id