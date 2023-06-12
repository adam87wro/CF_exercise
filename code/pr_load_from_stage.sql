--This procedure loads csv files from internal stage @CSVFILES to tables in schema 'csv_files'

CREATE OR REPLACE PROCEDURE couponfollow.csv_files.pr_load_from_stage()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN

    TRUNCATE TABLE couponfollow.csv_files.domain_names;
    COPY INTO couponfollow.csv_files.domain_names
    FROM @CSVFILES
    FILE_FORMAT = (FORMAT_NAME = my_csv_format)
    PATTERN =''.*DomainNames.*'' 
    ON_ERROR = ''skip_file''
	PURGE = TRUE
    FORCE = TRUE;

    TRUNCATE TABLE couponfollow.csv_files.advertisers;
    COPY INTO couponfollow.csv_files.advertisers
    FROM @CSVFILES
    FILE_FORMAT = (FORMAT_NAME = my_csv_format)
    PATTERN =''.*Advertisers.*'' 
    ON_ERROR = ''skip_file''
	PURGE = TRUE
    FORCE = TRUE;
  
    TRUNCATE TABLE couponfollow.csv_files.affiliate_network;
    COPY INTO couponfollow.csv_files.affiliate_network
    FROM @CSVFILES
    FILE_FORMAT = (FORMAT_NAME = my_csv_format)
    PATTERN =''.*Affiliate_Network.*'' 
    ON_ERROR = ''skip_file''
	PURGE = TRUE
    FORCE = TRUE;
  
    TRUNCATE TABLE couponfollow.csv_files.clicks;
    COPY INTO couponfollow.csv_files.clicks
    FROM @CSVFILES
    FILE_FORMAT = (FORMAT_NAME = my_csv_format)
    PATTERN =''.*Clicks.*'' 
    ON_ERROR = ''skip_file''
	PURGE = TRUE
    FORCE = TRUE;

    TRUNCATE TABLE couponfollow.csv_files.coupon_codes;
    COPY INTO couponfollow.csv_files.coupon_codes
    FROM @CSVFILES
    FILE_FORMAT = (FORMAT_NAME = my_csv_format)
    PATTERN =''.*CouponCodes.*'' 
    ON_ERROR = ''skip_file''
	PURGE = TRUE
    FORCE = TRUE;
  
    TRUNCATE TABLE couponfollow.csv_files.orders;
    COPY INTO couponfollow.csv_files.orders
    FROM @CSVFILES
    FILE_FORMAT = (FORMAT_NAME = my_csv_format)
    PATTERN =''.*Orders.*'' 
    ON_ERROR = ''skip_file''
	PURGE = TRUE
    FORCE = TRUE;
  
    TRUNCATE TABLE couponfollow.csv_files.page_views;
    COPY INTO couponfollow.csv_files.page_views
    FROM @CSVFILES
    FILE_FORMAT = (FORMAT_NAME = my_csv_format)
    PATTERN =''.*PageViews.*'' 
    ON_ERROR = ''skip_file''
	PURGE = TRUE
    FORCE = TRUE;

    TRUNCATE TABLE couponfollow.csv_files.partner_websites;
    COPY INTO couponfollow.csv_files.partner_websites
    FROM @CSVFILES
    FILE_FORMAT = (FORMAT_NAME = my_csv_format)
    PATTERN =''.*PartnerWebsites.*'' 
    ON_ERROR = ''skip_file''
	PURGE = TRUE
    FORCE = TRUE;

    TRUNCATE TABLE couponfollow.csv_files.promotions;
    COPY INTO couponfollow.csv_files.promotions
    FROM @CSVFILES
    FILE_FORMAT = (FORMAT_NAME = my_csv_format)
    PATTERN =''.*Promotions.*'' 
    ON_ERROR = ''skip_file''
	PURGE = TRUE
    FORCE = TRUE;
  
    TRUNCATE TABLE couponfollow.csv_files.currency_exchange_rates;
    INSERT INTO couponfollow.csv_files.currency_exchange_rates (currency, exchange_rate) VALUES
    (''USD'',1),
    (''CHF'',0.8989),
    (''EUR'',1.0819),
    (''GBP'',1.2464),
    (''CAD'',1.3508),
    (''AUD'',0.6661),
    (''AED'',3.67),
    (''INR'',82.65);
    commit;
  
END;
';