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
    , (case when b.gross_amount_eur is null then 'unknown' 
            when b.gross_amount_eur = p.paid_amount_eur then 'paid' 
            when (p.paid_amount_eur is not null and b.gross_amount_eur > p.paid_amount_eur) then 'partially_paid' 
            when (p.paid_amount_eur is not null and b.gross_amount_eur < p.paid_amount_eur) then 'overpaid' 
            else 'unpaid' end) as payment_status
    , b.property_country
    , b.property_id
    , b.property_type
    , b.property_star_rating
    , b.status
from bookings as b
left join payments as p on b.booking_id = p.booking_id