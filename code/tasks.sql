CREATE OR REPLACE TASK tp_load_from_stage
WAREHOUSE = couponfollow_wh
SCHEDULE = '60 MINUTE'
AS
CALL couponfollow.csv_files.pr_load_from_stage()
;

CREATE OR REPLACE TASK tch_load_data_model
WAREHOUSE = couponfollow_wh
AFTER tp_load_from_stage
AS
CALL couponfollow.model.pr_load_data_model()
;

--activate tasks
ALTER TASK tch_load_data_model RESUME;
ALTER TASK tp_load_from_stage RESUME;



