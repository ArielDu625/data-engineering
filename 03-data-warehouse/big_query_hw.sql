-- create external table from data in GCP bucket
CREATE EXTERNAL TABLE `i-matrix-435319-g3.ny_taxi.green_taxi_2022`
  OPTIONS (
    format ="PARQUET",
    uris = ['gs://i-matrix-435319-g3-ds-bucket/green_tripdata_2022-01.parquet',
            'gs://i-matrix-435319-g3-ds-bucket/green_tripdata_2022-02.parquet',
            'gs://i-matrix-435319-g3-ds-bucket/green_tripdata_2022-03.parquet',
            'gs://i-matrix-435319-g3-ds-bucket/green_tripdata_2022-04.parquet',
            'gs://i-matrix-435319-g3-ds-bucket/green_tripdata_2022-05.parquet',
            'gs://i-matrix-435319-g3-ds-bucket/green_tripdata_2022-06.parquet',
            'gs://i-matrix-435319-g3-ds-bucket/green_tripdata_2022-07.parquet',
            'gs://i-matrix-435319-g3-ds-bucket/green_tripdata_2022-08.parquet',
            'gs://i-matrix-435319-g3-ds-bucket/green_tripdata_2022-09.parquet',
            'gs://i-matrix-435319-g3-ds-bucket/green_tripdata_2022-10.parquet',
            'gs://i-matrix-435319-g3-ds-bucket/green_tripdata_2022-11.parquet',
            'gs://i-matrix-435319-g3-ds-bucket/green_tripdata_2022-12.parquet'
        ]
    );

-- create table
CREATE OR REPLACE TABLE ny_taxi.green_taxi_data_non_partitoned AS
SELECT * FROM `ny_taxi.green_taxi_2022`;

-- estimated amount of data that will be read is 0
select count(*) from `ny_taxi.green_taxi_2022`;

-- estimated amount of data that will be read is also 0
select count(*) from `ny_taxi.green_taxi_data_non_partitoned`;


-- estimated amount of data that will be read is 0
select count(distinct `PULocationID`)
from `ny_taxi.green_taxi_2022`;

-- estimated amount of data that will be read is 6.41 MB
select count(distinct `PULocationID`)
from `ny_taxi.green_taxi_data_non_partitoned`;


-- the query result is 1622
select count(*) 
from `ny_taxi.green_taxi_data_non_partitoned` as t
where t.fare_amount = 0;


-- Creating a partition and cluster table
CREATE OR REPLACE TABLE ny_taxi.green_taxi_data_partitioned
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY `PULocationID` AS
SELECT * FROM `ny_taxi.green_taxi_2022`;

-- Query scans 12.82 MB using the non-partitioned table, the query result is 242
SELECT count(distinct `PULocationID`)
FROM `ny_taxi.green_taxi_data_non_partitoned`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

-- Query scans 1.12 MB using the partitioned table, the query result is 242
SELECT count(distinct `PULocationID`)
FROM `ny_taxi.green_taxi_data_partitioned`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';
