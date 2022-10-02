import pymysql
import csv
import sys
import datetime
from redmail import EmailSender
import pandas as pd
from pathlib import Path
import chardet



#date block
today = datetime.date.today()
start_date=(today.strftime("%Y-%m-05 00:00:01"))
end_date=(today.strftime("%Y-%m-05 23:59:59"))

#email block

email = EmailSender(
    host='your email server',
    port=put here your email port,
)

#DB block
db_opts = {
    'user': '',
    'password': '',
    'host': '',
    'database': ''
}

db = pymysql.connect(**db_opts)
cur = db.cursor()
csv_file_path = 'name_of_your_csv_file.csv'


try:
    cur.execute("""SELECT * FROM BASE.table where column BETWEEN '%s' and '%s' ;""" % (start_date, end_date))
    rows = cur.fetchall()
finally:
    db.close()

# Continue only if there are rows returned.
if rows:
    # New empty list called 'result'. This wexit()ill be written to a file.
    result = list()

    # The row name is the first entry for each entity in the description tuple.
    column_names = list()
    for i in cur.description:
        column_names.append(i[0])

    result.append(column_names)
    for row in rows:
        result.append(row)

    # Write result to file.
    with open(csv_file_path, 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        for row in result:
            csvwriter.writerow(row)
else:
    sys.exit("No rows found for query: {}".format(sql))

read_file = pd.read_csv (r'name_of_your_csv_file.csv',sep=',',encoding='UTF-8')
read_file.to_excel (r'name_of_your_xlsx_file.xlsx', index = None, header=True)


email.send(
    subject="Put your subject here",
    sender="sender-report@domain.com",
    receivers=['recipient@domain.com'],
    cc=['recipient2@domain.com'],
    html="""
<p>Вітаю </p>
<p>Це автоматична вигрузка по [your system name] </p>
<p>У вкладенні файл name_of_your_xlsx_file.xlxs - вигрузка за попередній місяць з [your system name]</p>
""",
        attachments={
        'name_of_your_xlsx_file.xlsx': Path('./name_of_your_xlsx_file.xlsx')
                }
)

