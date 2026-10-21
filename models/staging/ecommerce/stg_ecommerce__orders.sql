with 

source as (
    select * from {{ source('raw_ecommerce', 'raw_orders') }}
),

renamed_and_cleaned as (
    select
        cast(id as integer) as order_id,
        cast(user_id as integer) as customer_id,
        cast(order_date as date) as order_date,
        lower(trim(status)) as status
    from source
)

select * from renamed_and_cleaned