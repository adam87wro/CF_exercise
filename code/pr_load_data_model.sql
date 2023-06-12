--This procedure loads data to model in schema 'model'

CREATE OR REPLACE PROCEDURE couponfollow.model.pr_load_data_model()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN
	BEGIN TRANSACTION;

	DELETE FROM couponfollow.model.fact_orders;
	DELETE FROM couponfollow.model.dim_clicks;
	DELETE FROM couponfollow.model.dim_page_views;
	DELETE FROM couponfollow.model.dim_domain_names;
	DELETE FROM couponfollow.model.dim_advertisers;
	DELETE FROM couponfollow.model.dim_affiliate_network;
	DELETE FROM couponfollow.model.page_views_clicks_bridge;
	DELETE FROM couponfollow.model.dim_currency_exchange_rates;
	DELETE FROM couponfollow.model.dim_coupons;
	DELETE FROM couponfollow.model.dim_promotions;

    INSERT INTO couponfollow.model.dim_domain_names (id, domainname)
    SELECT 
		domainnameid, 
		domainname 
	FROM couponfollow.csv_files.domain_names;
   
    INSERT INTO couponfollow.model.dim_advertisers (id, advertisername, affiliatenetworkid)
    SELECT 
		advertiserid, 
		advertisername, 
		affiliatenetworkid 
	FROM couponfollow.csv_files.advertisers;
   
    INSERT INTO couponfollow.model.dim_affiliate_network (id, affiliatenetworkname)
    SELECT 
		affiliatenetworkid, 
		affiliatenetworkname 
	FROM couponfollow.csv_files.affiliate_network;
    
    INSERT INTO couponfollow.model.page_views_clicks_bridge (id)
    SELECT 
		DISTINCT couponfollow_session_id 
	FROM couponfollow.csv_files.clicks 
    WHERE 1=1 and couponfollow_session_id is not null
    UNION
    SELECT 
		DISTINCT user_session_id 
	FROM couponfollow.csv_files.page_views 
	WHERE 1=1 and user_session_id is not null;

    INSERT INTO couponfollow.model.dim_currency_exchange_rates (id,exchange_rate)
    SELECT 
		currency, 
		exchange_rate 
	FROM couponfollow.csv_files.currency_exchange_rates;

    INSERT INTO couponfollow.model.dim_coupons (offer_id, domainnameid, coupon_code, isexclusive, expiredate, catclastsavingon)
    SELECT 
		(''cc/'' || couponcodeid), 
		domainnameid, 
		coupon_code, 
		isexclusive, expiredate, 
		catclastsavingon 
	FROM couponfollow.csv_files.coupon_codes;

    INSERT INTO couponfollow.model.dim_promotions (offer_id,domainnameid, expiredate)
    SELECT 
		(''promo/'' || promotionid), 
		domainnameid, 
		expiredate 
	FROM couponfollow.csv_files.promotions;

    INSERT INTO couponfollow.model.dim_page_views (id, email_profile_id, campaign_id, domain_name_id, user_session_id, page_view_at_pt,
					      						   page_title, city, country, region_name, browser_name, operating_system_version, device_name)
    SELECT 
		pageviews.event_id, 
		pageviews.email_profile_id, 
		pageviews.campaign_id, 
		domain.domainnameid, 
		pageviews.user_session_id, 
		pageviews.page_view_at_pt,
		pageviews.page_title, 
		pageviews.city, 
		pageviews.country, 
		pageviews.region_name, 
		pageviews.browser_name, 
		pageviews.operating_system_version, 
		pageviews.device_name
	FROM couponfollow.csv_files.page_views pageviews
	LEFT JOIN couponfollow.csv_files.domain_names domain ON domain.domainname = pageviews.domain_name; 

    INSERT INTO couponfollow.model.dim_clicks (id, domainnameid, offer_id, couponfollow_session_id, partnerwebsiteid)
    SELECT 
		clicks.clickid, 
		domain.domainnameid, 
		clicks.offer_id, 
		clicks.couponfollow_session_id, 
		clicks.partnerwebsiteid 
	FROM couponfollow.csv_files.clicks clicks
	LEFT JOIN couponfollow.csv_files.domain_names domain ON domain.domainname = clicks.domainname;


	INSERT INTO couponfollow.model.fact_orders (id, clickid, domainnameid, createdon, transactiondate, saleamount, commissionamount,
										   currency, affiliatenetworkid, advertiserid)
	SELECT 
		orders.orderid, 
		orders.clickid, 
		domain.domainnameid, 
		orders.createdon, 
		orders.transactiondate, 
		orders.saleamount, 
		orders.commissionamount, 
		orders.currency, 
		orders.affiliatenetworkid, 
		try_cast(orders.advertiserid as integer)
	FROM couponfollow.csv_files.orders orders
	LEFT JOIN couponfollow.csv_files.clicks clicks ON orders.clickid = clicks.clickid
	LEFT JOIN couponfollow.csv_files.domain_names domain ON domain.domainname = clicks.domainname;

    commit; 

EXCEPTION
	WHEN OTHER THEN
	ROLLBACK;
	RAISE;
     
END;
';