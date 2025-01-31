import os
import argparse

from time import time

import pandas as pd
from sqlalchemy import create_engine


def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url


    if url.endswith('.csv.gz'):
        csv_name = 'taxi_zone_lookup_table.csv.gz'
    else:
        csv_name = 'taxi_zone_lookup_table.csv'
    
    os.system(f'wget {url} -O {csv_name}')

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    df = pd.read_csv(csv_name)
    df.head(n = 0).to_sql(name = table_name, con = engine, if_exists = "replace")

    df.to_sql(name = table_name, con = engine, if_exists="append")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Ingest csv data to Postgres")

    parser.add_argument("--user", required=True, help='user name for postgres')
    parser.add_argument("--password", required=True, help='password for postgres')
    parser.add_argument("--host", required=True, help='host for postgres')
    parser.add_argument("--port", required=True, help='port for postgres')
    parser.add_argument("--db", required=True, help='database name for postgres')
    parser.add_argument("--table_name", required=True, help='name of the table where data will be inserted into')
    parser.add_argument("--url", required=True, help='url of the csv file')

    args = parser.parse_args()
    main(args)
