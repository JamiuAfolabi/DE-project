import pandas as pd
from sqlalchemy import create_engine

def taxi_ingest():
    engine = create_engine('postgresql://ny_taxi:password@host:port/ny_taxi')
    csv_name = 'yellow_tripdata.csv'
    table_name = 'ny_taxi'

    df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000)
    df = next(df_iter)

    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

    df.to_sql(name=table_name, con=engine, if_exists='append')

    count = 0
    while True:
        count += 1
        try:
            df = next(df_iter)
            df.to_sql(name=table_name,con=engine,if_exists='append')
            print(f'Data ingestion {count}')
        except Exception as e:
            print('Data ingestion completed')
            break
    



