with 
receipts as (
	select * from {{ ref('stg_receipts') }}
),
receipt_items as (
	select * from {{ ref('stg_receipt_items') }}
),

recent_month as (
    select date_trunc('month', max(scanned_ts)) as latest_month
    from receipts
),
filtered_receipts as (
    select 
		r.receipt_id,
		ri.barcode
    from receipts r
	join receipt_items ri on r.receipt_id = ri.receipt_id
    where date_trunc('month', r.scanned_ts) = (
        select latest_month from recent_month
    )
)

select * from filtered_receipts
