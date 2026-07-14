--model name: int_payments.sql

{{
  config(
    tags=['booking']
  )
}}

with payments as (
    select * from {{ ref('stg_payments') }}
)

, fx_rates as (
    select * from {{ ref('stg_fx_rates') }}
)

select
    p.booking_id
    , p.amount
    , p.currency
    , p.first_paid_at
    , round(p.amount * fx.rate_to_eur, 2) as paid_amount_eur
    , p.payment_method
from payments as p
left join fx_rates as fx on p.currency = fx.currency