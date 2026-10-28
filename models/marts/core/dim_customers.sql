with customers as (
    select * from {{ ref('stg_ecommerce__customers') }}
),

orders as (
    select * from {{ ref('fct_orders') }}
),

customer_orders_summary as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as total_orders,
        sum(case when order_status != 'returned' then order_amount_usd else 0 end) as lifetime_value_usd
    from orders
    group by customer_id
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['customers.customer_id']) }} as customer_key,
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customers.email,
        coalesce(summary.first_order_date, null) as first_order_date,
        coalesce(summary.most_recent_order_date, null) as most_recent_order_date,
        coalesce(summary.total_orders, 0) as number_of_orders,
        coalesce(summary.lifetime_value_usd, 0.0) as lifetime_value_usd,
        case 
            when summary.total_orders > 0 then 'active'
            else 'inactive'
        end as customer_lifecycle_stage
    from customers
    left join customer_orders_summary as summary
        on customers.customer_id = summary.customer_id
)

select * from final