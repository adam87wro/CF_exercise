CREATE OR REPLACE TABLE couponfollow.model.dim_domain_names(
	id INT NOT NULL,
	domainname VARCHAR(100),
	CONSTRAINT PK_Domain_id PRIMARY KEY (id)
);

CREATE OR REPLACE TABLE couponfollow.model.dim_advertisers(
	id int NOT NULL,
	advertisername VARCHAR(200),
	affiliatenetworkid INT,
	CONSTRAINT PK_Advertisers_id PRIMARY KEY (id)
);

CREATE OR REPLACE TABLE couponfollow.model.dim_currency_exchange_rates(
	id VARCHAR(3) NOT NULL,
	exchange_rate float,
	CONSTRAINT PK_Currency_id PRIMARY KEY (id)
);

CREATE OR REPLACE TABLE couponfollow.model.dim_affiliate_network(
	id INT NOT NULL,
	affiliatenetworkname VARCHAR(200),
	CONSTRAINT PK_Affiliate_network_id PRIMARY KEY (id)
);

CREATE OR REPLACE TABLE couponfollow.model.page_views_clicks_bridge(
	id VARCHAR(1000) NOT NULL,
	CONSTRAINT PK_Page_views_clicks_bridge_id PRIMARY KEY (id)
);

CREATE OR REPLACE TABLE couponfollow.model.dim_coupons(
	offer_id VARCHAR(200)NOT NULL,
	domainnameid INT,
	coupon_code VARCHAR(200),
	isexclusive VARCHAR(10),
	expiredate TIMESTAMP_TZ,
	catclastsavingon TIMESTAMP_TZ,
	CONSTRAINT PK_Coupon_codes_id PRIMARY KEY (offer_id)
);

CREATE OR REPLACE TABLE couponfollow.model.dim_promotions(
	offer_id VARCHAR(200) NOT NULL,
	domainnameid int,
	expiredate TIMESTAMP_TZ,
	CONSTRAINT PK_promotions_id PRIMARY KEY (offer_id)
);

CREATE OR REPLACE TABLE couponfollow.model.dim_page_views(
	id VARCHAR(1000) NOT NULL,
	email_profile_id VARCHAR(100),
	campaign_id VARCHAR(100),
	--domain_name VARCHAR(100),
	domain_name_id INT,
	user_session_id VARCHAR(1000),
	page_view_at_pt TIMESTAMP_TZ,
	page_title VARCHAR(2000),
	city VARCHAR(100),
	country VARCHAR(2),
	region_name VARCHAR(100),
	browser_name VARCHAR(100),
	operating_system_version VARCHAR(10),
	device_name VARCHAR(100),
	CONSTRAINT PK_Page_views_id PRIMARY KEY (id),
	CONSTRAINT FK_PageViewsDomains FOREIGN KEY (domain_name_id)
	    REFERENCES couponfollow.model.dim_domain_names(id),
	CONSTRAINT FK_PageViewsClicks FOREIGN KEY (user_session_id)
	    REFERENCES couponfollow.model.page_views_clicks_bridge(id)    
);

CREATE OR REPLACE TABLE couponfollow.model.dim_clicks(
	id INT,
	domainnameid INT,
	offer_id VARCHAR(200),
	couponfollow_session_id VARCHAR(1000),
	partnerwebsiteid INT,
	CONSTRAINT PK_Clicks_id PRIMARY KEY (id),
	CONSTRAINT FK_ClicksPageViews FOREIGN KEY (couponfollow_session_id)
	    REFERENCES couponfollow.model.page_views_clicks_bridge(id), 
	CONSTRAINT FK_ClicksCoupons FOREIGN KEY (offer_id)
	    REFERENCES couponfollow.model.dim_coupons(offer_id),
	CONSTRAINT FK_ClicksPromotions FOREIGN KEY (offer_id)
	    REFERENCES couponfollow.model.dim_promotions(offer_id),
	CONSTRAINT FK_ClicksDomain FOREIGN KEY (domainnameid)
	    REFERENCES couponfollow.model.dim_domain_names(id)
);

CREATE OR REPLACE TABLE couponfollow.model.fact_orders(
	id INT NOT NULL,
	clickid INT,
	domainnameid INT,
	createdon TIMESTAMP_TZ,
	transactiondate TIMESTAMP_TZ,
	saleamount FLOAT,
	commissionamount FLOAT,
	currency VARCHAR(3),
	affiliatenetworkid INT,
	advertiserid INT,
	CONSTRAINT PK_Orders_id PRIMARY KEY (id),
	CONSTRAINT FK_ClickOrders FOREIGN KEY (clickid)
	    REFERENCES couponfollow.model.dim_clicks(id),
	CONSTRAINT FK_DomainOrders FOREIGN KEY (domainnameid)
	    REFERENCES couponfollow.model.dim_domain_names(id),
	CONSTRAINT FK_AdvertisersOrders FOREIGN KEY (advertiserid)
	    REFERENCES couponfollow.model.dim_advertisers(id),
	CONSTRAINT FK_AffiliateNetworkOrders FOREIGN KEY (affiliatenetworkid)
	    REFERENCES couponfollow.model.dim_affiliate_network(id),
	CONSTRAINT FK_CurrencyOrders FOREIGN KEY (currency)
	    REFERENCES couponfollow.model.dim_currency_exchange_rates(id)	
);

