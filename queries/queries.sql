--Top 3 retailers/advertisers by revenue
--I added 'dim_currency_exchange_rates' table to data model and unified currencies to USD
SELECT top 3 
	advertisers.advertisername AS advertiser_name, 
	sum(orders.commissionamount*currency.exchange_rate) AS revenue_usd
FROM couponfollow.model.fact_orders orders
JOIN couponfollow.model.dim_advertisers advertisers ON orders.advertiserid = advertisers.id
JOIN couponfollow.model.dim_currency_exchange_rates currency ON orders.currency = currency.id 
GROUP BY advertisers.advertisername
ORDER BY sum(orders.commissionamount*currency.exchange_rate) DESC



--Top 3 retailers/advertisers by page views
SELECT top 3 
	advertisers.advertisername AS advertiser_name,  
	count(DISTINCT pviews.id) AS page_views
FROM couponfollow.model.dim_advertisers advertisers
JOIN couponfollow.model.fact_orders orders ON orders.advertiserid = advertisers.id 
JOIN couponfollow.model.dim_clicks clicks ON clicks.id = orders.clickid  
JOIN couponfollow.model.dim_page_views pviews ON pviews.user_session_id = clicks.couponfollow_session_id
GROUP BY advertisers.advertisername
ORDER BY count(DISTINCT pviews.id) DESC



--Average Commission Rate (Commission Rate = commissions/sale amount)
--Number of unique page views
SELECT
	sum(orders.commissionamount)/sum(orders.saleamount) AS avg_commission_rate,
	(SELECT count(id) AS number_of_unique_page_views
	 FROM couponfollow.model.dim_page_views) AS number_of_unique_page_views
FROM couponfollow.model.fact_orders orders



--Rolling sum of order count
SELECT 
	id, 
	SUM(count(*)) OVER (ORDER BY id asc) as rolling_sum
FROM couponfollow.model.fact_orders
GROUP BY id
ORDER BY id asc

--I prepared query which groups by 'transactiondate'
SELECT 
	LEFT(transactiondate,10) AS transaction_date,
	SUM(count(*)) OVER (ORDER BY LEFT(transactiondate,10)  asc) as rolling_sum
FROM couponfollow.model.fact_orders
GROUP BY LEFT(transactiondate,10) 
ORDER BY LEFT(transactiondate,10)  ASC




--Month-over-month comparison of revenue broken down by affiliate network (is revenue going up or down for the various affiliate networks?)
--Revenues in 2022-03 were lower than in 2022-02 for every affiliate network 
SELECT
	affnetwork.affiliatenetworkname  AS affiliate_network_name, 
	LEFT(orders.transactiondate,7) AS revenue_month,
	sum(orders.commissionamount*currency.exchange_rate) AS revenue_usd,
	sum(orders.commissionamount*currency.exchange_rate) - LAG(sum(orders.commissionamount*currency.exchange_rate)) OVER (PARTITION BY affnetwork.affiliatenetworkname ORDER BY LEFT(orders.transactiondate,7) ASC) AS revenue_usd_diff
FROM couponfollow.model.fact_orders orders
JOIN couponfollow.model.dim_affiliate_network affnetwork ON orders.affiliatenetworkid  = affnetwork.id
JOIN couponfollow.model.dim_currency_exchange_rates currency ON orders.currency = currency.id 
GROUP BY affnetwork.affiliatenetworkname, LEFT(orders.transactiondate,7) 
ORDER BY affnetwork.affiliatenetworkname, LEFT(orders.transactiondate,7)  ASC

