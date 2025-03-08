
with

stg_brands as (
	select * from {{ ref('stg_brands') }}
),
dim_brands as (
	select * from {{ ref('dim_companies') }}
),

names_remapped as (
	select
		s.brand_id,
		s.barcode,
		s.category,
		s.category_code,
		s.cpg_id,
		s.name as item_name,
		d.company as company_name,
		s.top_brand as top_brand,
		s.brand_code as brand_code
	
	from stg_brands s
	join dim_brands d
	on s.cpg_id = d.cpg_id
)


select * from names_remapped 
