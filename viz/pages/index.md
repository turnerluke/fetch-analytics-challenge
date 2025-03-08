---
title: Turner Luke's Fetch Analytics Engineer Exercise
queries:
  - brand_transactions_new_users.sql
  - brand_spend_new_users.sql
  - spend_per_receipt_by_status.sql
  - num_items_per_receipt_by_status.sql
---

## What are the top 5 brands by receipts scanned for most recent month?

## How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

## When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

<BarChart
    data={spend_per_receipt_by_status}
    x=rewards_receipt_status
    y=avg_spend_usd
/>

## When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

<BarChart
    data={num_items_per_receipt_by_status}
    x=rewards_receipt_status
    y=total_items_purchased
/>

## Which brand has the most spend among users who were created within the past 6 months?

<BarChart
    data={brand_spend_new_users}
    x=brand_name
    y=total_usd
    swapXY=false
/>

## Which brand has the most transactions among users who were created within the past 6 months?

<BarChart
    data={brand_transactions_new_users}
    x=brand_name
    y=transaction_count
    swapXY=false
/>

_Made by [Turner Luke](https://www.linkedin.com/in/turnermluke/)_
