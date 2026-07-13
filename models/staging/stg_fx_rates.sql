--model name: stg_fx_rates.sql

with source as (
    select
        fx.currency
        , fx.as_of_date	
        , fx.rate_to_eur	
    from {{ source('source_csv','fx_rates') }} as fx
)

select * from source