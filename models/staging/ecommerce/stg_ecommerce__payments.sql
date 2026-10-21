with 

source as (
    select * from {{ source('raw_ecommerce', 'raw_payments') }}
),

renamed_and_cleaned as (
    select
        cast(id as integer) as payment_id,
        cast(order_id as integer) as order_id,
        lower(trim(payment_method)) as payment_method,
        round(cast(amount_cents as double) / 100.0, 2) as amount_usd
    from source
)

select * from renamed_and_cleaned