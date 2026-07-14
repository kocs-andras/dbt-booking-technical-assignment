--model name: stg_fx_rates.sql

{{
  config(
    tags=['booking']
  )
}}

with source as (
    select
        fx.as_of_date
        , fx.currency
        , fx.rate_to_eur
    from {{ source('source_csv','fx_rates') }} as fx
)

, processed as (
    select
        {{ dbt_utils.generate_surrogate_key(['s.currency','s.as_of_date']) }} as fx_rates_id
        , s.as_of_date
        , s.currency
        , s.rate_to_eur
    from source as s
)

select * from processed