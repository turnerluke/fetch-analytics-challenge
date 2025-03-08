with source as (
    select * from {{ source('raw', 'brands') }}
),

preprocessed as (
    select
        struct_extract(id, 'oid') as brand_id, -- Extract MongoDB ObjectId
        barcode::varchar as barcode,
        lower(trim(category)) as category,
        lower(trim(category_code)) as category_code,
        lower(trim(cpg ->> 'id' ->> 'oid')) as cpg_id,  -- Extract the reference ID from JSON
        lower(trim(name)) as name,
		case when top_brand = 1 then true else false end as top_brand,
        lower(trim(brand_code)) as brand_code,
        row_number() over (
            partition by brand_id
        ) as row_num
    from source
),

deduplicated as (
    select
        brand_id, 
        barcode,
        category,
        category_code,
        cpg_id,
        name,
        top_brand,
        brand_code
    from preprocessed
    where row_num = 1
),

cleaned as (
	select
		*
	from
		preprocessed
	where
		name not ilike '%test%'
		and
		brand_code is not Null
)

select * from cleaned

