
CREATE OR REPLACE TABLE couponfollow.csv_files.domain_names(
	domainnameid int,
	domainname varchar(100)
);

CREATE OR REPLACE TABLE couponfollow.csv_files.advertisers(
	advertiserid int,
	advertisername varchar(200),
	affiliatenetworkid int
);

CREATE OR REPLACE TABLE couponfollow.csv_files.affiliate_network(
	affiliatenetworkid int,
	affiliatenetworkname varchar(200)
);

CREATE OR REPLACE TABLE couponfollow.csv_files.clicks(
	clickid int,
	domainname varchar(200),
	offer_id varchar(200),
	couponfollow_session_id varchar(200),
	partnerwebsiteid int
);

CREATE OR REPLACE TABLE couponfollow.csv_files.coupon_codes(
	couponcodeid int,
	domainnameid int,
	coupon_code varchar(200),
	isexclusive varchar(10),
	expiredate TIMESTAMP_TZ,
	catclastsavingon TIMESTAMP_TZ
);

CREATE OR REPLACE TABLE couponfollow.csv_files.orders(
	orderid int,
	clickid int,
	createdon timestamp_tz,
	transactiondate timestamp_tz,
	saleamount float,
	commissionamount float,
	currency varchar(3),
	affiliatenetworkid int,
	advertiserid varchar(20)
);

CREATE OR REPLACE TABLE couponfollow.csv_files.page_views(
	event_id varchar(100),
	email_profile_id varchar(100),
	campaign_id varchar(100),
	domain_name varchar(100),
	user_session_id varchar(200),
	page_view_at_pt TIMESTAMP_TZ,
	page_title varchar(2000),
	city varchar(100),
	country varchar(2),
	region_name varchar(100),
	browser_name varchar(100),
	operating_system_version varchar(10),
	device_name varchar(100)
);

CREATE OR REPLACE TABLE couponfollow.csv_files.partner_websites(
	partnerwebsiteid int,
	name varchar(100)
);

CREATE OR REPLACE TABLE couponfollow.csv_files.promotions(
	promotionid int,
	domainnameid int,
	expiredate TIMESTAMP_TZ
);

CREATE OR REPLACE TABLE couponfollow.csv_files.currency_exchange_rates(
	currency VARCHAR(3),
	exchange_rate float
);
