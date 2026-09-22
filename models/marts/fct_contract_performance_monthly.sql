with monthly_bookings as (

    select
        contract_id,
        date_trunc('month', booking_date)::date as reporting_month,
        sum(booking_amount) as booking_amount

    from {{ ref('fct_bookings') }}

    group by
        contract_id,
        date_trunc('month', booking_date)::date

),
monthly_revenue as (

    select
        contract_id,
        date_trunc('month', accounting_period)::date as reporting_month,
        sum(recognized_revenue) as recognized_revenue

    from {{ ref('fct_recognized_revenue') }}

    group by
        contract_id,
        date_trunc('month', accounting_period)::date

),


monthly_cash as (

    select
        contract_id,
        date_trunc('month', receipt_date)::date as reporting_month,
        sum(cash_amount) as cash_collected

    from {{ ref('fct_cash_collected') }}

    group by
        contract_id,
        date_trunc('month', receipt_date)::date

),


contract_months as (

    select contract_id, reporting_month
    from monthly_bookings

    union

    select contract_id, reporting_month
    from monthly_revenue

    union

    select contract_id, reporting_month
    from monthly_cash

),

financial_metrics as (

    select
        cm.contract_id,
        cm.reporting_month,

        coalesce(b.booking_amount, 0) as booking_amount,
        coalesce(r.recognized_revenue, 0) as recognized_revenue,
        coalesce(c.cash_collected, 0) as cash_collected

    from contract_months cm

    left join monthly_bookings b
        on cm.contract_id = b.contract_id
        and cm.reporting_month = b.reporting_month

    left join monthly_revenue r
        on cm.contract_id = r.contract_id
        and cm.reporting_month = r.reporting_month

    left join monthly_cash c
        on cm.contract_id = c.contract_id
        and cm.reporting_month = c.reporting_month

),

contract_enriched as (

    select
        fm.contract_id,
        fm.reporting_month,

        c.finance_customer_id,
        c.salesforce_opportunity_id,
        c.contract_execution_date,
        c.contract_status,

        x.enterprise_customer_key,
        x.salesforce_account_id,

        fm.booking_amount,
        fm.recognized_revenue,
        fm.cash_collected

    from financial_metrics fm

    left join {{ ref('int_finance__contract_validated') }} c
        on fm.contract_id = c.contract_id

    left join {{ ref('stg_finance__customer_xref') }} x
        on c.finance_customer_id = x.finance_customer_id

),

final as (

    select
        ce.contract_id,
        ce.reporting_month,

        -- Enterprise customer identity
        ce.enterprise_customer_key,
        ce.finance_customer_id,
        ce.salesforce_account_id,

        -- Contract attributes
        ce.salesforce_opportunity_id,
        ce.contract_execution_date,
        ce.contract_status,

        -- Salesforce customer attributes
        opp.account_name,
        opp.industry,
        opp.account_type,
        opp.annual_revenue,

        -- Salesforce opportunity attributes
        opp.opportunity_name,
        opp.opportunity_stage,

        -- Sales organization
        opp.sales_rep_id,
        opp.sales_rep_name,
        opp.sales_rep_email,
        opp.sales_rep_is_active,

        -- Governed financial measures
        ce.booking_amount,
        ce.recognized_revenue,
        ce.cash_collected,

        -- Makes missing cross-system mapping visible
        case
            when ce.enterprise_customer_key is not null
                then 'MAPPED'
            else 'UNMAPPED'
        end as customer_mapping_status

    from contract_enriched ce

    left join {{ ref('int_salesforce__opportunity_enriched') }} opp
        on ce.salesforce_opportunity_id = opp.opportunity_id

)

select *
from final