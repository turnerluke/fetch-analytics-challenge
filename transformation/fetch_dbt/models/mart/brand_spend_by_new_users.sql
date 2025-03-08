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

spend_by_brand as (
    select 
        ri.brand_code,
        sum(r.total_spent) as total_spend
    from receipts r
    join receipt_items ri on r.receipt_id = ri.receipt_id
    where r.user_id in (select user_id from new_users)
    group by ri.brand_code
),

top_brands as (
    select 
        b.name as brand_name,
        s.total_spend
    from 
		spend_by_brand s
    join 
		brands b 
	on 
		s.brand_code = b.brand_code
    order by 
		s.total_spend desc
    limit 
		10
)

select * from top_brands

