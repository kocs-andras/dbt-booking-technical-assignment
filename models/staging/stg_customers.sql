--model name: stg_customers.sql

{{
  config(
    tags=['booking']
  )
}}

with source as (
    select
        c.customer_id	
        , c.country	
        , c.loyalty_tier
        , c.signup_date
    from {{ source('source_csv','customers') }} as c
)

, processed as (
    select
        s.customer_id	
        , s.country	
        , coalesce(s.loyalty_tier,'Blue') as loyalty_tier
        , s.signup_date
    from source as s
)

select * from processed