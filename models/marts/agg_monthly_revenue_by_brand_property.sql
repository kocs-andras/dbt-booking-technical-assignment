--model name: agg_monthly_revenue_by_brand_property.sql

{{
  config(
    tags=['booking']
  )
}}

with bookings as (
    select * from {{ ref('bookings') }} as b
    /*{% if is_incremental() %}
        where b.booking_month >= date_sub((select max(booking_month) from {{ this }}), interval 1 month)
    {% endif %}*/
)

, monthly_aggregate as (
    select
        {{ dbt_utils.generate_surrogate_key(['b.booking_month','b.brand','b.property_type']) }} as id
        , b.booking_month
        , b.brand
        , b.property_type
        , round(
            safe_divide(
                sum(case when b.status in ('confirmed','completed') then b.gross_amount_eur else 0 end)
                , count(distinct case when b.status in ('confirmed','completed') then b.booking_id end)
            )
            , 2
        ) as avg_confirmed_revenue_per_booking_eur
        , round(
            safe_divide(
                sum(case when b.status in ('confirmed','completed') then b.paid_amount_eur else 0 end) 
                , sum(case when b.status in ('confirmed','completed') then b.gross_amount_eur else 0 end)
            )
            , 4
        ) as pct_paid_revenue
        , count(distinct b.booking_id) as total_bookings
        , count(distinct case when b.status in ('confirmed','completed') then b.booking_id end) as total_confirmed_bookings
        , round(sum(case when b.status in ('confirmed','completed') then b.gross_amount_eur else 0 end), 2) as total_confirmed_revenue_eur
        , round(sum(case when b.status in ('confirmed','completed') then b.paid_amount_eur else 0 end), 2) as total_paid_revenue_eur
    from bookings as b
    group by 1,2,3,4
)

select
    ma.id
    , ma.booking_month
    , ma.brand
    , ma.property_type
    , ma.avg_confirmed_revenue_per_booking_eur
    , ma.pct_paid_revenue
    , sum(ma.total_confirmed_bookings) over (
        partition by ma.brand, ma.property_type
        order by ma.booking_month
        rows between 11 preceding and current row
    ) as rolling_confirmed_bookings_L12
    , sum(ma.total_confirmed_bookings) over (
        partition by ma.brand, ma.property_type
        order by ma.booking_month
    ) as rolling_total_confirmed_bookings
    , sum(ma.total_confirmed_revenue_eur) over (
        partition by ma.brand, ma.property_type
        order by ma.booking_month
        rows between 11 preceding and current row
    ) as rolling_confirmed_revenue_eur_L12
    , sum(ma.total_confirmed_revenue_eur) over (
        partition by ma.brand, ma.property_type
        order by ma.booking_month
    ) as rolling_total_confirmed_revenue_eur
    , sum(ma.total_paid_revenue_eur) over (
        partition by ma.brand, ma.property_type
        order by ma.booking_month
        rows between 11 preceding and current row
    ) as rolling_paid_revenue_eur_L12
    , sum(ma.total_paid_revenue_eur) over (
        partition by ma.brand, ma.property_type
        order by ma.booking_month
    ) as rolling_total_paid_revenue_eur
    , ma.total_bookings
    , ma.total_confirmed_bookings
    , ma.total_confirmed_revenue_eur
    , ma.total_paid_revenue_eur
from monthly_aggregate as ma