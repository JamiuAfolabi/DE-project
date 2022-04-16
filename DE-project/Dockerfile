FROM python:3.9
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY data_ingest.py .
COPY data_ingest_zone.py .
COPY run.py .

COPY yellow_tripdata.csv yellow_tripdata.csv
COPY taxi+_zone_lookup.csv taxi+_zone_lookup.csv

ENTRYPOINT ["python","run.py"]

