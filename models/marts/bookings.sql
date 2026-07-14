--model name: bookings.sql

{{
  config(
    tags=['booking']
  )
}}

with bookings as (
    select * from {{ ref('int_bookings') }}
)

, payments as (
    select * from {{ ref('int_payments') }}
)

select
    b.booking_id
    , b.booked_at
    , b.booking_month
    , b.brand
    , b.channel
    , b.checkin_date
    , b.checkout_date
    , b.customer_country
    , b.customer_id
    , b.customer_loyalty_tier
    , p.first_paid_at
    , b.gross_amount_eur
    , b.nights
    , p.paid_amount_eur
    , b.property_country
    , b.property_id
    , b.property_type
    , b.property_star_rating
    , b.status
from bookings as b
left join payments as p on b.booking_id = p.booking_id