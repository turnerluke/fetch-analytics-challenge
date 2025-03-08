with receipts as (
    select * from {{ ref('stg_receipts') }}
),

filtered_receipts as (
    select 
        rewards_receipt_status,
        avg(total_spent) as avg_spend
    from receipts
    group by rewards_receipt_status
)

select * from filtered_receipts

