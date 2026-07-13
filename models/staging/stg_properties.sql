--model name: stg_properties.sql

with source as (
    select
        p.property_id
        , p.brand
        , p.country
        , p.property_type
        , p.star_rating
    from {{ source('source_csv','properties') }} as p
)

select * from source