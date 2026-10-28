{% snapshot snap_customers %}

{{
    config(
        target_schema='main',
        unique_key='customer_id',
        strategy='check',
        check_cols=['email']
    )
}}

select 
    customer_id,
    first_name,
    last_name,
    email
from {{ ref('stg_ecommerce__customers') }}

{% endsnapshot %}