import datetime as dt

from airflow import DAG
from airflow.operators.mssql_operator import MsSqlOperator
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator

from secrets import connection


def toMSSQL():
      pass

def queryConvertRate():
      pass

def toExcel():
      pass


default_args = {
    'owner': 'nmema',
    'start_date': dt.datetime(2021, 4, 18),
    'retries': 1,
    'retry_delay': dt.timedelta(minutes=5),
}

with  DAG('RGA',
          default_args=default_args,
          schedule_interval='@once') as dag:

    getFiles = BashOperator(task_id='getFiles',
                            bash_command='ls files/*.xlsx > output.txt')
    
    loadData = PythonOperator(task_id='loadData',
                              python_callable=toMSSQL)
    
    normalizeEmployee = MsSqlOperator(task_id='normalizeEmployee',
                                      mssql_conn_id=connection,
                                      script='sripts/2_a_clean_employee_roster_data.sql')
    
    normalizeSkills = MsSqlOperator(task_id='normalizeSkills',
                                    mssql_conn_id=connection,
                                    script='sripts/2_b_clean_skills.sql')
 
    normalizeHours = MsSqlOperator(task_id='normalizeHours',
                                   mssql_conn_id=connection,
                                   script='sripts/2_c_clean_hours.sql')
    
    exportTables = PythonOperator(task_id='exportTables',
                                  python_callable=toExcel)
    
    convertRateUSD = PythonOperator(task_id='convertRateUSD',
                                    python_callable=queryConvertRate)
 
 
getFiles >> loadData >> normalizeEmployee >> [normalizeSkills, normalizeHours] >> exportTables >> convertRateUSD
