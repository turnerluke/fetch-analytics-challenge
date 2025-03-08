with source as (
    select * from {{ source('raw', 'users') }}
),

typed as (
    select
        struct_extract(id, 'oid') as user_id,
        coalesce(active, false) as active,
        epoch_ms(struct_extract(created_date, 'date')) as created_ts,
        epoch_ms(struct_extract(last_login, 'date')) as last_login_ts,
        lower(trim(role)) as role,
        lower(trim(sign_up_source)) as sign_up_source,
        lower(trim(state)) as state,
        row_number() over (
            partition by user_id
        ) as row_num
    from source
),

deduplicated as (
    select
        user_id, 
        active,
        created_ts,
        last_login_ts,
        role,
        sign_up_source,
        state
    from 
		typed
    where 
		row_num = 1
),

cleaned as (
	select
		user_id,
		active,
		created_ts,
		last_login_ts,
		role,
		sign_up_source,
		state
	from 
		deduplicated
	where
		role <> 'fetch-staff'

)

select * from cleaned

