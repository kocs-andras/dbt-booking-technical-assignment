--model name: stg_properties.sql

{{
  config(
    tags=['booking']
  )
}}

with source as (
    select
        p.property_id
        , p.brand
        , p.country
        , p.property_type
        , p.star_rating
    from {{ source('source_csv','properties') }} as p
)

, processed as (
    select
        s.property_id
        , s.brand
        , s.country
        , lower(trim(s.property_type)) as property_type
        , s.star_rating
    from source as s
)

select * from processed