### Question 1: Knowing docker tags

docker run --rm  will automatically remove the container and its associated anonymous volumes when it exits


### Question 2: Understanding docker first run

run docker with the python:3.9 image in an interactive mode and the entrypoint of bash using command:
```bash
docker run -it --entrypoint /bin/bash python:3.9
```

and then check the installed python modules with command
```bash
pip list
```

the version of the package wheel is 0.44.0


### Question 3:

insert green_tripdata_2019-09 into database by running ingest_green_taxi_data.py locally:

```bash
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz"

python ingest_green_taxi_data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --table_name=green_taxi_data \
  --url=${URL}

```

insert taxi_zone_lookup_table.csv into database by running ingest_taxi_zone_data.py locally:

```bash
URL="https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv"

python ingest_taxi_zone_data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --table_name=taxi_zone_lookup \
  --url=${URL}

```

Then execute the query
```sql
SELECT count(*)
FROM green_taxi_data
where DATE(lpep_pickup_datetime) = TO_DATE('2019-09-18', 'YYYY-MM-DD')
and DATE(lpep_dropoff_datetime) = TO_DATE('2019-09-18', 'YYYY-MM-DD')
```
The returned result is 15612


### Question 4: Longest trip for each day

```sql
SELECT DATE(lpep_pickup_datetime) AS pickup_date,
		trip_distance AS longest_trip
FROM green_taxi_data
WHERE trip_distance = (
	SELECT 
        MAX(trip_distance)
	FROM green_taxi_data
)
```
The returned result show that 2019-09-26 has the longest trip which is 341.64

### Question 5: Three biggest pick up Boroughs

```sql
select taxi_zone_lookup."Borough",
		sum(green_taxi_data.total_amount)
from green_taxi_data
left join taxi_zone_lookup
on green_taxi_data."PULocationID" = taxi_zone_lookup."LocationID"
where date(green_taxi_data.lpep_pickup_datetime) = to_date('2019-09-18','YYYY-MM-DD')
and taxi_zone_lookup."Borough" != 'Unknown'
group by taxi_zone_lookup."Borough"
having sum(green_taxi_data.total_amount) > 50000
```
the returned result show that "Brooklyn", "Manhattan" and "Queens" had a sum of total amount greater than 50000

### Question 6: Largetst tip
```sql
select green_taxi_data."DOLocationID",
		   green_taxi_data.tip_amount,
		   taxi_zone_lookup."Zone"
from green_taxi_data
left join taxi_zone_lookup
on green_taxi_data."DOLocationID" = taxi_zone_lookup."LocationID"
where green_taxi_data.tip_amount = (
	select max(green_taxi_data.tip_amount)
	from green_taxi_data
	left join taxi_zone_lookup
	on green_taxi_data."PULocationID" = taxi_zone_lookup."LocationID"
	where to_char(green_taxi_data.lpep_pickup_datetime, 'YYYY-MM') = '2019-09'
	and taxi_zone_lookup."Zone" = 'Astoria'
)
```

the returned result show that "JFK Airport" was the drop off zone that had the largest tip

### Question 7: Creating Resources

