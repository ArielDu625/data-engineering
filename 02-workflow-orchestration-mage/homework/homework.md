### Question 1:
Once the dataset is loaded, the shape of the data is 266855 x 20 columns

### Question 2:
After filtering the dataset where the passenger count is greater than 0 and the trip distance is greater than zero, there are 139370 columns left.


### Question 3:
The correction way of creating new column should be:

```python
data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date
```

### Question 4:
the existing values of VendorID in the dataset is 1 or 2

### Question 5:
4 columns need to be renamed to snake case, they are: VendorID, RatecodeID, PULocationID, and DOLocationID

### Question 6:
There are 95 partitions in google cloud after exported.
