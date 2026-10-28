{%- set payment_methods = ['credit_card', 'gift_card', 'bank_transfer'] -%}

with payments as (
    select * from {{ ref('stg_ecommerce__payments') }}
),

pivoted as (
    select
        order_id,
        {% for payment_method in payment_methods -%}
        sum(
            case 
                when payment_method = '{{ payment_method }}' then amount_usd 
                else 0 
            end
        ) as {{ payment_method }}_amount,
        {% endfor -%}
        sum(amount_usd) as total_amount_usd
    from payments
    group by order_id
)

select * from pivoted