with receipts as (
    select * from {{ ref('stg_receipts') }}
),
receipt_items as (
    select * from {{ ref('stg_receipt_items') }}
),

filtered_items as (
    select 
        r.rewards_receipt_status,
        sum(ri.quantity_purchased) as total_items_purchased
    from receipts r
    join receipt_items ri on r.receipt_id = ri.receipt_id
    group by r.rewards_receipt_status
)

select * from filtered_items

