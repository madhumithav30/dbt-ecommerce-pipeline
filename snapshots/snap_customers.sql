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
    id as customer_id,
    first_name,
    last_name,
    email
from {{ source('raw_ecommerce', 'raw_customers') }}

{% endsnapshot %}