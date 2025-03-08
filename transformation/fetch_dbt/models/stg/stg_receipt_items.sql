with source as (
    select * from {{ source('raw', 'receipts') }}
),

unnested as (
    select 
        r.id ->> 'oid' as receipt_id,
        unnest(r.rewards_receipt_item_list) as item
    from source r
),

cleaned as (
    select
        receipt_id,

        -- Extracting fields from the JSON struct
        item ->> 'barcode' as barcode,
        lower(trim(item ->> 'description')) as description,

        -- Price and Discount Fields
        cast(item ->> 'discounted_item_price' as float) as discounted_item_price,
        cast(item ->> 'final_price' as float) as final_price,
        cast(item ->> 'item_price' as float) as item_price,
        lower(trim(item ->> 'original_receipt_item_text')) as original_receipt_item_text,
        cast(item ->> 'partner_item_id' as float) as partner_item_id,  -- Ensure it matches Pydantic's Optional[str]

        cast(item ->> 'price_after_coupon' as float) as price_after_coupon,
        cast(item ->> 'quantity_purchased' as float) as quantity_purchased,
        cast(item ->> 'points_earned' as float) as points_earned,
        lower(trim(item ->> 'brand_code')) as brand_code,

        -- 🏗️ Boolean Fields
        cast(item ->> 'needs_fetch_review' as boolean) as needs_fetch_review,
        cast(item ->> 'prevent_target_gap_points' as boolean) as prevent_target_gap_points,
        cast(item ->> 'user_flagged_new_item' as boolean) as user_flagged_new_item,
        cast(item ->> 'competitive_product' as boolean) as competitive_product,
        cast(item ->> 'deleted' as boolean) as deleted,

        -- 🏗️ Additional Metadata Fields
        lower(trim(item ->> 'needs_fetch_review_reason')) as needs_fetch_review_reason,
        lower(trim(item ->> 'points_not_awarded_reason')) as points_not_awarded_reason,
        lower(trim(item ->> 'points_payer_id')) as points_payer_id,
        lower(trim(item ->> 'rewards_group')) as rewards_group,
        lower(trim(item ->> 'rewards_product_partner_id')) as rewards_product_partner_id,
        lower(trim(item ->> 'user_flagged_description')) as user_flagged_description,
        lower(trim(item ->> 'original_meta_brite_barcode')) as original_meta_brite_barcode,
        lower(trim(item ->> 'original_meta_brite_description')) as original_meta_brite_description,
        lower(trim(item ->> 'competitor_rewards_group')) as competitor_rewards_group,
        lower(trim(item ->> 'item_number')) as item_number,

        cast(item ->> 'original_meta_brite_quantity_purchased' as float) as original_meta_brite_quantity_purchased,
        cast(item ->> 'target_price' as float) as target_price,
        cast(item ->> 'original_final_price' as float) as original_final_price,
        cast(item ->> 'original_meta_brite_item_price' as float) as original_meta_brite_item_price,

        lower(trim(item ->> 'metabrite_campaign_id')) as metabrite_campaign_id,

        -- Deduplication logic
        row_number() over (
            partition by receipt_id, barcode 
            order by final_price desc nulls last
        ) as row_num
    from unnested
),

deduplicated as (
    select
        receipt_id,
        barcode,
        description,
        discounted_item_price,
        final_price,
        item_price,
        original_receipt_item_text,
        partner_item_id,
        price_after_coupon,
        quantity_purchased,
        points_earned,
        brand_code,
        needs_fetch_review,
        prevent_target_gap_points,
        user_flagged_new_item,
        competitive_product,
        deleted,
        needs_fetch_review_reason,
        points_not_awarded_reason,
        points_payer_id,
        rewards_group,
        rewards_product_partner_id,
        user_flagged_description,
        original_meta_brite_barcode,
        original_meta_brite_description,
        competitor_rewards_group,
        item_number,
        original_meta_brite_quantity_purchased,
        target_price,
        original_final_price,
        original_meta_brite_item_price,
        metabrite_campaign_id
    from cleaned
    where row_num = 1
)

select * from deduplicated

