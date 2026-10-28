{{
    config(
        materialized='incremental',
        unique_key='sale_date'
    )
}}

with orders as (
    select * from {{ ref('fct_orders') }}
),

daily_aggregation as (
    select
        order_date as sale_date,
        count(distinct order_id) as total_orders,
        count(distinct customer_id) as active_customers,
        sum(order_amount_usd) as total_revenue_usd,
        round(avg(order_amount_usd), 2) as average_order_value_usd
    from orders
    where order_status != 'returned'

    {% if is_incremental() %}
        -- Changed 'where' to 'and' because a WHERE clause already exists above
        and order_date >= (select coalesce(max(sale_date), cast('1970-01-01' as date)) from {{ this }})
    {% endif %}

    group by order_date
)

select * from daily_aggregation