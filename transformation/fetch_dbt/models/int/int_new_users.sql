with

int_users as (
    select * from {{ ref('int_users') }}
),

max_created_ts as (
	select
		max(created_ts) as max_ts
	from
		int_users
),

new_users as (
    select 
		u.user_id,
		u.created_ts,
		u.created_month
    from 
		int_users u
	cross join 
		max_created_ts m
    where 
		u.created_ts >= date_trunc('month', m.max_ts) - interval '6 months'
)

select * from new_users

