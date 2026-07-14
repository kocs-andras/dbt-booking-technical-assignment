--model name: agg_monthly_revenue_by_brand_property.sql

with bookings as (
    select * from {{ ref('bookings') }}
)

select
    b.booking_month
    , b.brand
    , b.property_type
    , count(distinct b.booking_id) as total_bookings
    , round(
        safe_divide(
            sum(case when b.status in ('confirmed','completed') then b.paid_amount_eur else 0 end) 
            , sum(case when b.status in ('confirmed','completed') then b.gross_amount_eur else 0 end)
        )
        , 4
    ) as pct_paid_revenue
    , round(sum(case when b.status in ('confirmed','completed') then b.gross_amount_eur else 0 end), 2) as total_confirmed_revenue_eur
    , round(sum(case when b.status in ('confirmed','completed') then b.paid_amount_eur else 0 end), 2) as total_paid_revenue_eur
from bookings as b
group by 1,2,3