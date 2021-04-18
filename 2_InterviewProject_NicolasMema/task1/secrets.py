api_key = '<fixer_api_key>'
convert_date = "2017-04-03"

mssql_user = '<user_name>'
mssql_pass = '<user_password>'

server = "<server>"
db = "<database>"
driver = "<driver>".replace(" ", "+")
connection = "mssql+pyodbc://{}:{}@{}/{}?driver={}".format(mssql_user,
                                                mssql_pass,
                                                server,
                                                db,
                                                driver)
