FROM python:3.9
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY data_ingest.py .
COPY yellow_tripdata.csv yellow_tripdata.csv
ENTRYPOINT ["python","data_ingest.py"]

