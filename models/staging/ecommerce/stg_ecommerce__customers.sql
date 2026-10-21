with 

source as (
    select * from {{ source('raw_ecommerce', 'raw_customers') }}
),

renamed_and_cleaned as (
    select
        cast(id as integer) as customer_id,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        lower(trim(email)) as email
    from source
)

select * from renamed_and_cleaned