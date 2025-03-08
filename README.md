# Turner Luke's Fetch Analytics Engineer Coding Challenge

# Structure Relational Data Model

![Fetch Relation Diagram](./assets/database_relations_diagram.png?raw=true)

# Stakeholder Questions

## What are the top 5 brands by receipts scanned for most recent month?

## How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

## When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

`rewardsReceiptStatus` has 5 possible observed values: (rejected, pending, submitted, flagged, finished). It is assumed that the question asking for 'Accepted' is 'finished'.

'finished' has a 247% greater average spend (80.85) than 'rejected' (23.33).

## When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

As above, we will take 'Accepted' to be 'finished'.

'finished' has a much larger total number of items purchased (2487) compared to 'rejected' (135).

## Which brand has the most spend among users who were created within the past 6 months?

When performing this analysis, a critical assumption was made to consider users with the last six months of observed data. Otherwise, if looking from the last six months from the current month (March 2025) there is no data for new users.

Pepsi was the brand with the most spend among new users, with 33,063.63 spent.

## Which brand has the most transactions among users who were created within the past 6 months?

With the same stipulations on new users above, Pepsi was the brand with the most transactions among new users, with 15 transactions.

# Data Quality Issues

users.json.gz has leading and trailing characters that required manual cleaning. The source of this file needs to be audited to ensure reliable data pipelines.

These datasets contain large amounts of test data. Much care was taken to clean it, however, it may be valuable to dig deeper into the data sources and see if it can be cleaned upstream.

Some examples of test data cleaned are:

- Test brands in `brands`
- Fetch staff users in `users`
- Duplicte data among all datasets

# Communicate with Stakeholders
