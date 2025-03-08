
with 

-- Get most recent month’s receipts
recent_month_receipts as (
    select * from {{ ref('int_most_recent_month_scanned_receipts') }}
),

-- Brand reference table
brands as (
    select * from {{ ref('stg_brands') }}
),

-- Join receipts with brands using barcode and count distinct receipts by brand_code
receipt_count_by_brand as (
    select 
        b.name as brand_name,
        b.brand_code,
        count(distinct r.receipt_id) as receipt_count
    from recent_month_receipts r
    join brands b on r.barcode = b.barcode
    group by b.name, b.brand_code
),

-- Rank brands by receipt count
ranked_brands as (
    select 
        brand_name, 
        brand_code,
        receipt_count,
        row_number() over (order by receipt_count desc) as rank
    from receipt_count_by_brand
)

--select * from ranked_brands
select * from receipt_count_by_brand
