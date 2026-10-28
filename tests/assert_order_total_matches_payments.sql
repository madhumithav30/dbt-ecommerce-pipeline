-- Singular test: Assert that order total equals the sum of its itemized payment methods.
-- If any row returns an absolute variance > 0.01 (accounting for floating-point rounding), the test fails.

with orders as (
    select * from {{ ref('fct_orders') }}
),

validation as (
    select
        order_id,
        order_amount_usd,
        (credit_card_amount + gift_card_amount + bank_transfer_amount) as calculated_payment_total,
        abs(order_amount_usd - (credit_card_amount + gift_card_amount + bank_transfer_amount)) as variance
    from orders
)

select *
from validation
where variance > 0.01