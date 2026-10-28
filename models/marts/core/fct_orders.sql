with orders as (
    select * from {{ ref('stg_ecommerce__orders') }}
),

order_payments as (
    select * from {{ ref('int_payments_pivoted_to_orders') }}
),

final as (
    select
        -- Surrogate Key (Industry standard for warehouse dimensions/facts)
        {{ dbt_utils.generate_surrogate_key(['orders.order_id']) }} as order_key,
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status as order_status,
        
        -- Metrics from intermediate layer
        coalesce(order_payments.credit_card_amount, 0) as credit_card_amount,
        coalesce(order_payments.gift_card_amount, 0) as gift_card_amount,
        coalesce(order_payments.bank_transfer_amount, 0) as bank_transfer_amount,
        coalesce(order_payments.total_amount_usd, 0) as order_amount_usd
    from orders
    left join order_payments 
        on orders.order_id = order_payments.order_id
)

select * from final