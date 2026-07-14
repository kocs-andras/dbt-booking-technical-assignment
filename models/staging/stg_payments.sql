--model name: stg_payments.sql

{{
  config(
    tags=['booking']
  )
}}

with source as (
    select
        p.payment_id
        , p.amount
        , p.booking_id
        , p.currency
        , p.paid_at
        , p.payment_method
    from {{ source('source_csv','payments') }} as p
)

, processed as (
    select
        s.payment_id
        , s.amount
        , s.booking_id
        , s.currency
        , s.paid_at as first_paid_at
        , s.payment_method
        , row_number() over (partition by s.booking_id order by s.paid_at asc) as rnk
    from source as s
    qualify rnk = 1
)

select * except (rnk) from processed