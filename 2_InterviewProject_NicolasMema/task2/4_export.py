import os
import pandas as pd
import sqlalchemy
import pyodbc
from secrets import connection, mssql_user, mssql_pass, db

query = "SELECT TABLE_NAME FROM {}.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'".format(db)
command = os.popen('sqlcmd -S localhost -U {} -P {} -Q "{}"'.format(mssql_user,
                                                                    mssql_pass,
                                                                    query))
output = command.read()
tables = [table.replace(' ', '') for table in output.split('\n')]
tables = tables [2:-3]

for table in tables:
    engine = sqlalchemy.create_engine(connection)
    query = 'SELECT * FROM {}'.format(table)
    df = pd.read_sql(query, con=engine)
    df.to_excel('output/{}.xlsx'.format(table), index=False)
    print('Table', table, 'exported.')
print('Process ran successful.')

