print("AJT SCRIPT AUTOMATIVE")
import time
import pandas as pd
import pyodbc
DRIVER_NAME = 'SQL SERVER'
SERVER_NAME = '192.168.0.25'
DATABASE_NAME='msdb'

def read(conn):
    print('Read')
    cursor = conn.cursor()
    #cursor.execute("SELECT * FROM [msdb].[dbo].[sysjobhistory2] WHERE run_date = '20221107'")
    cursor.execute("EXEC msdb.dbo.sp_help_jobactivity @job_name = 'LastPriceImport'")
    for row in cursor:
        print(f'row = {row}')
    print()    

conx = pyodbc.connect('DRIVER={SQL SERVER}; SERVER=192.168.0.25; Database=msdb; UID=sa; PWD=SpawnGG;')


read(conx)
from datetime import datetime
sleep_time_day = 2
sleep_time_night = 30
i=0;
while 1<2:
    current = datetime.now()
    print("looping...")
    filename = "file"+str(i)+".txt"
    with open(filename, 'a') as f:
        temp = current.strftime("%d/%m/%Y %H:%M:%S")
        f.write('\n'+str(current)+' test')
        f.close()
    if(current.hour >= 7 and current.hour <= 24):
        time.sleep(sleep_time_day)
    else:
        time.sleep(sleep_time_night)

    


