import pyarrow as pa
import pyarrow.parquet as pq
import os

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = "/home/src/ariel_gcp.json"

bucket_name = "i-matrix-435319-g3-ds-bucket"
project_id = 'i-matrix-435319-g3'

table_name = "ny_green_taxi"
root_path = f"{bucket_name}/{table_name}"

@data_exporter
def export_data(data, *args, **kwargs):
    partition_cols = kwargs['configuration'].get('partition_cols')
    partition_cols = partition_cols.split(",")
    
    now = kwargs.get('execution_date')
    path = root_path + f"_{now.strftime('%Y-%m-%d')}"

    table = pa.Table.from_pandas(data)

    gcs = pa.fs.GcsFileSystem()

    pq.write_to_dataset(
        table,
        root_path=path,
        partition_cols=partition_cols,
        filesystem=gcs
    )
