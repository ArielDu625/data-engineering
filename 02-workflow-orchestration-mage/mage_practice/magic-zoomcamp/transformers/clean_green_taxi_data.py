import inflection

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    data = data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0)]
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date
    data.rename(columns = inflection.underscore, inplace=True)

    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert 'vendor_id' in output.columns, "Rename Columns in Camel Case to Snake Case failed"
    assert output['passenger_count'].isin([0]).sum() == 0, "There are rides with zero passengers"
    assert output[output['trip_distance'] == 0]['trip_distance'].sum() == 0, "There are rides with zero distance"
