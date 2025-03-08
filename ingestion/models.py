from typing import Optional

from pydantic import BaseModel, Field


class MongoId(BaseModel):
    oid: str = Field(alias="$oid")


class MongoDate(BaseModel):
    date: int = Field(alias="$date")


class CpgReference(BaseModel):
    id: Optional[MongoId] = Field(alias="$id")
    ref: Optional[str] = Field(alias="$ref")


class Users(BaseModel):
    id: MongoId = Field(alias="_id")
    active: bool
    created_date: MongoDate
    last_login: Optional[MongoDate]
    role: str
    sign_up_source: Optional[str]
    state: Optional[str]


class Brands(BaseModel):
    id: MongoId = Field(alias="_id")
    barcode: str
    category: Optional[str]
    category_code: Optional[str]
    cpg: CpgReference
    name: str
    top_brand: Optional[float]
    brand_code: Optional[str]


class RewardsReceiptItem(BaseModel):
    barcode: Optional[str]
    description: Optional[str]
    final_price: Optional[str]
    item_price: Optional[str]
    needs_fetch_review: Optional[bool]
    partner_item_id: Optional[str]
    prevent_target_gap_points: Optional[bool]
    quantity_purchased: Optional[float]
    user_flagged_barcode: Optional[str]
    user_flagged_new_item: Optional[bool]
    user_flagged_price: Optional[str]
    user_flagged_quantity: Optional[float]
    needs_fetch_review_reason: Optional[str]
    points_not_awarded_reason: Optional[str]
    points_payer_id: Optional[str]
    rewards_group: Optional[str]
    rewards_product_partner_id: Optional[str]
    user_flagged_description: Optional[str]
    original_meta_brite_barcode: Optional[str]
    original_meta_brite_description: Optional[str]
    brand_code: Optional[str]
    competitor_rewards_group: Optional[str]
    discounted_item_price: Optional[str]
    original_receipt_item_text: Optional[str]
    item_number: Optional[str]
    original_meta_brite_quantity_purchased: Optional[float]
    points_earned: Optional[str]
    target_price: Optional[str]
    competitive_product: Optional[bool]
    original_final_price: Optional[str]
    original_meta_brite_item_price: Optional[str]
    deleted: Optional[bool]
    price_after_coupon: Optional[str]
    metabrite_campaign_id: Optional[str] = Field(None)


class Receipts(BaseModel):
    id: MongoId = Field(alias="_id")
    bonus_points_earned: Optional[float]
    bonus_points_earned_reason: Optional[str]
    create_date: MongoDate
    date_scanned: MongoDate
    finished_date: Optional[MongoDate]
    modify_date: MongoDate
    points_awarded_date: Optional[MongoDate]
    points_earned: Optional[float]
    purchase_date: Optional[MongoDate]
    purchased_item_count: Optional[float]
    rewards_receipt_item_list: Optional[list[RewardsReceiptItem]] = Field(
        default_factory=list
    )
    rewards_receipt_status: str
    total_spent: Optional[float]
    user_id: str
