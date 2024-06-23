import pyodbc

conn_string=(r"DRIVER={ODBC Driver 17 for SQL Server};SERVER=SERVERNAME;DATABASE=Test;Trusted_Connection=yes"
)

conn=pyodbc.connect(conn_string)

cursor=conn.cursor()
# calling the stored procedure that was created in 02_stored_procedures_triggers.sql
stored_procedure="{CALL InsertUpdateTransactions (?,?,?,?)}"

cursor.execute(stored_procedure,("Test","2024-06-09","LIDL",555))

conn.commit()

cursor.close()
conn.close()