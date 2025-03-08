with 

new_users as (
    select * from {{ ref('int_new_users') }}
),
receipts as (
    select * from {{ ref('stg_receipts') }}
),
receipt_items as (
    select * from {{ ref('stg_receipt_items') }}
),
brands as (
    select * from {{ ref('stg_brands') }}
),

transactions_by_brand as (
    select 
        ri.brand_code,
        count(distinct r.receipt_id) as transaction_count
    from receipts r
    join receipt_items ri on r.receipt_id = ri.receipt_id
    where r.user_id in (select user_id from new_users)
    group by ri.brand_code
),

top_brands as (
    select 
        b.name as brand_name,
        t.transaction_count
    from transactions_by_brand t
    join brands b on t.brand_code = b.brand_code
    order by t.transaction_count desc
    limit 10
)

select * from top_brands

