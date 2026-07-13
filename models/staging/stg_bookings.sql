--model name: stg_bookings.sql

with source as (
    select
        b.booking_id
        , b.booked_at
        , b.brand
        , b.channel
        , b.checkin_date
        , b.checkout_date
        , b.currency
        , b.customer_id
        , b.gross_amount
        , b.nights
        , b.property_id
        , b.status
    from {{ source('source_csv','bookings') }} as b
)

, processed as (
    select
        s.booking_id
        , s.booked_at
        , s.brand
        , s.channel
        , coalesce(s.checkin_date, date_sub(s.checkout_date, interval s.nights day)) as checkin_date
        , s.checkout_date
        , s.currency
        , s.customer_id
        , s.gross_amount
        , s.nights
        , s.property_id
        , s.status
        , row_number () over (partition by s.booking_id order by s.booked_at desc) as rnk
    from source as s
    qualify rnk = 1
)

select * except (rnk) from processed