with

stg_users as (
    select * from {{ ref('stg_users') }}
),

new_users as (
    select
		*,
		date_trunc('month', created_ts) as created_month
    from stg_users
)

select * from new_users
