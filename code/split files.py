'''
This script splits files into smaller chunks - expected size is set in variable 'expected_size'
'''

import csv
import os
import datetime

list_of_files = ('Advertisers.csv','Affiliate_Network.csv','Clicks.csv','CouponCodes.csv','DomainNames.csv','Orders.csv','PageViews.csv','PartnerWebsites.csv','Promotions.csv')

path_read = r'C:\Users\adam8\Desktop\project_CouponFollow\Data'
loaddate = datetime.datetime.now().strftime('%Y%m%d_%Hh%M')
for l in list_of_files:
    full_file_path = path_read + str('\\') + l
    path_write = r'C:\Users\adam8\Desktop\project_CouponFollow\Data\csv_upload' + str('\\') + l.replace(".csv","")
    size = os.path.getsize(full_file_path)
    size_mb = (size/1024)/1024

    with open(full_file_path, encoding="utf-8", newline='') as infile:
        reader = csv.DictReader(infile)
        header = reader.fieldnames
        rows = [row for row in reader]
        pages = []

        row_count = len(rows)
        start_index = 0

        # define number of rows to save in 1 file
        size = os.path.getsize(full_file_path)
        size_mb = (size / 1024) / 1024
        expected_size = int('200')
        size_ratio = size_mb/expected_size
        rows_per_csv = round(row_count/size_ratio)

        # slice the total rows into pages, each page having 'row_per_csv' rows
        while start_index < row_count:
            pages.append(rows[start_index: start_index + rows_per_csv])
            start_index += rows_per_csv

        # write rows into new files to directory 'path_write'
        for i, page in enumerate(pages):
            with open('{}_{}_{}.csv'.format(path_write, i+1,loaddate), 'w+', encoding="utf-8") as outfile:
                writer = csv.DictWriter(outfile, delimiter=',', lineterminator='\n', fieldnames=header)
                writer.writeheader()
                for row in page:
                    writer.writerow(row)
