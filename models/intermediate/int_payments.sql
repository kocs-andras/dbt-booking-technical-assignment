--model name: int_payments.sql

with payments as (
    select * from {{ ref('stg_payments') }}
)

, fx_rates as (
    select * from {{ ref('stg_fx_rates') }}
)

select
    p.booking_id
    , p.first_paid_at
    , round(p.amount * fx.rate_to_eur, 2) as paid_amount_eur
from payments as p
left join fx_rates as fx on p.currency = fx.currency