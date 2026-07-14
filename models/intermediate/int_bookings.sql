--model name: int_bookings.sql

{{
  config(
    tags=['booking']
  )
}}

with bookings as (
    select * from {{ ref('stg_bookings') }}
)

, customers as (
    select * from {{ ref('stg_customers') }}
)

, fx_rates as (
    select * from {{ ref('stg_fx_rates') }}
)

, properties as (
    select * from {{ ref('stg_properties') }}
)

select
    b.booking_id
    , b.booked_at
    , date_trunc(cast(b.booked_at as date), month) as booking_month
    , b.brand
    , b.channel
    , b.checkin_date
    , b.checkout_date
    , b.currency
    , c.country as customer_country
    , b.customer_id
    , c.loyalty_tier as customer_loyalty_tier
    , b.gross_amount
    , round(b.gross_amount * fx.rate_to_eur, 2) as gross_amount_eur
    , b.nights
    , p.country as property_country
    , b.property_id
    , p.property_type
    , p.star_rating as property_star_rating
    , b.status
from bookings as b
left join customers as c on b.customer_id = c.customer_id
left join fx_rates as fx on b.currency = fx.currency
left join properties as p on b.property_id = p.property_id