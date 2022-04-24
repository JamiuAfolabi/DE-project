import pandas as pd
from sqlalchemy import create_engine


engine = create_engine('postgresql://user:password@ip:5432/db')
csv_name = 'yellow_tripdata.csv'
table_name = 'ny_taxi'

df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000)
df = next(df_iter)

df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

df.to_sql(name=table_name, con=engine, if_exists='append')

while True:
    try:
        df = next(df_iter)
        df.to_sql(name=table_name,con=engine,if_exists='append')
    except Exception as e:
        print('Data ingestion completed')
        break
    



