import cx_Oracle
import cx_Oracle as orc
import csv
from datetime import date, timedelta
from redmail import EmailSender
import pandas as pd
from pathlib import Path
import chardet

#time block
last_day_of_prev_month = date.today().replace(day=1) - timedelta(days=1)
start_day_of_prev_month = date.today().replace(day=1) - timedelta(days=last_day_of_prev_month.day)
start_date=(start_day_of_prev_month.strftime("%d-%m-%Y"))
last_date=(last_day_of_prev_month.strftime("%d-%m-%Y"))


#email block
email = EmailSender(
    host='your email server',
    port=put here your poort,
)


#DB block
user= 'put here your user'
pwd = 'put here your passw'
host = 'put here your HOST' #could look like path or url depending on where it's hosted
service_name = 'put here your oracle DB service name '
portno = 1521

#Start
con = cx_Oracle.connect(user, pwd, '{}:{}/{}'.format(host,portno,service_name))
cursor = con.cursor()
csv_file = open("put_here_your filename.csv", "w")
writer = csv.writer(csv_file, delimiter=',', lineterminator="\n", quoting=csv.QUOTE_NONNUMERIC)
r = cursor.execute("""
select *  from table
c where
c.some row BETWEEN to_date('%s','DD-MM-YYYY') and to_date('%s','DD-MM-YYYY') """ % (start_date, last_date))
    writer.writerow(row)

cursor.close()
con.close()
csv_file.close()
#End writing data into put_here_your_CSV_filename.csv

#Convert csv file to xlsx
read_file = pd.read_csv (r'put_here_your_filename.csv',sep=',',encoding='UTF-8')
read_file.to_excel (r'put_here_your_xlsx_filename.xlsx', index = None, header=True)

email.send(
    subject="Your subject",
    sender="Sender@domain.com",
    receivers=['some@domain.com'],
    cc=['some@domain.com'],
    html="""
<p>Your </p>
<p>Message text here</p>
<p></p>
""",
        attachments={
        'put_here_your_xlsx_filename.xlsx': Path('./put_here_your_xlsx_filename.xlsx')
                }
)

