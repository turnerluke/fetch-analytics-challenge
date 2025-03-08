with source as (
    select * from {{ source('raw', 'receipts') }}
),

cleaned as (
    select
        struct_extract(id, 'oid') as receipt_id, -- Extract MongoDB ObjectId
        user_id,
        total_spent,

        -- Convert UNIX timestamps (milliseconds) to DATE
        epoch_ms(struct_extract(purchase_date, 'date')) as purchase_ts,
        epoch_ms(struct_extract(create_date, 'date')) as create_ts,
        epoch_ms(struct_extract(modify_date, 'date')) as modify_ts,
        epoch_ms(struct_extract(points_awarded_date, 'date')) as points_awarded_ts,
        epoch_ms(struct_extract(finished_date, 'date')) as finished_ts,
        epoch_ms(struct_extract(date_scanned, 'date')) as scanned_ts,

        -- Ensure float values are properly cast
        cast(points_earned as float) as points_earned,
        cast(bonus_points_earned as float) as bonus_points_earned,

        -- Normalize text fields
        lower(trim(rewards_receipt_status)) as rewards_receipt_status,

        -- Deduplication logic
        row_number() over (
            partition by receipt_id
        ) as row_num
    from source
),

deduplicated as (
    select
        receipt_id, 
        user_id,
        total_spent,
        purchase_ts,
        create_ts,
        modify_ts,
        points_awarded_ts,
        finished_ts,
		scanned_ts,
        points_earned,
        bonus_points_earned,
        rewards_receipt_status
    from cleaned
    where row_num = 1
)

select * from deduplicated

