import requests
from secrets import api_key, convert_date, connection
import pandas as pd
import sqlalchemy
import pyodbc


def convertion_usd(salary, currency):
    rate = rates[currency]
    return round(salary / rate, 2) if currency != 'USD' else round(salary, 2)


df = pd.read_excel('./Employee_Roster_Data.xlsx')
currency = list(df['Currency'].unique())

url = "http://data.fixer.io/api/" + convert_date + \
      "?access_key=" + api_key + \
      "&symbols=" + ','.join(currency)


re = requests.get(url)
rates = re.json()['rates']

df['Salary'] = df.apply(lambda x: convertion_usd(x['Salary'], x['Currency']), axis=1)
df['Currency'] = 'USD'

engine = sqlalchemy.create_engine(connection)
df.to_sql("Employee_Roster_Data", con=engine, if_exists='replace', index=False)

# DROP table before running next task.
