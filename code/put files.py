
'''
This script loads files into snowflake internal stage @CSVFILES
'''

import snowflake.connector as sn

# define connection to snowflake
ctx = sn.connect(
    authenticator='snowflake',
    user='XXXXXXXXX',
    password='XXXXXXXXX',
    account='XXXXXXXXX',
    warehouse='COUPONFOLLOW_WH',
    database='COUPONFOLLOW',
    schema='CSV_FILES'
    )
cs = ctx.cursor()

list_of_files = ('Advertisers','Affiliate_Network','Clicks','CouponCodes','DomainNames','Orders','PageViews','PartnerWebsites','Promotions')
path_read = r'C:\Users\adam8\Desktop\project_CouponFollow\Data\csv_upload'

# remove all files in @CSVFILES internal stage
cs.execute(r"remove @CSVFILES;")

# load all files from directory 'path_read', which have names similar to names defined in 'list_of_files'
for l in list_of_files:
    cs.execute(str('put file://') + path_read + str('\\') + l + str('*.csv @CSVFILES;'))

cs.close()
ctx.close()