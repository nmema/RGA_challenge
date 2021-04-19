import os
import pandas as pd
import sqlalchemy
import pyodbc
from secrets import connection


def get_files():
    xlsx = os.popen('ls files/*.xlsx')
    output = xlsx.read()
    files = output.split('\n')[:-1]
    return files

def to_mssql(files):

    for file in files:
        df = pd.read_excel(file)
        # little format
        df.columns = df.columns.str.lower()
        df.columns = df.columns.str.replace(' ', '_')
        df.columns = df.columns.str.replace('-', '_')
        # export
        table_name = os.path.basename(file).split('.')[0].lower()
        engine = sqlalchemy.create_engine(connection)
        df.to_sql(table_name, con=engine, if_exists='replace', index=False)
        print('table {} created.'.format(table_name))
    print('Process ran successful.')

files = get_files()
to_mssql(files)
