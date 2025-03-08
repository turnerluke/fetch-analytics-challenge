
select
	rewards_receipt_status,
	avg_spend as avg_spend_usd  -- Automatically formats as $X,XXX
from
	fetch_db.spend_receipt_status
