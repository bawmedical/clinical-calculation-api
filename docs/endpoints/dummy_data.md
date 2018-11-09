# Dummy Data

Often when developing a health application, you need lots of clinically-plausible data to use for testing datat flows, user interfaces, and persistence validations. Unfortunately, unless you have access to a ready supply of this data, it can be hard to come by. In theory it's usually not hard to fake, after all it will often just be a Normal (Gaussian) distribution of data. But even so it can require a certain amount of clinical acumen and understanding to be able to make plausible results.

This endpoint is currently limited to producing plausible blood glucose and HbA1c measurements for an average, clinically well Type 2 diabetic, returning plausible random blood glucose and HbA1c measurements.

## How to use it
The public testing version of the API is at

    http://clinical-calculator-api.herokuapp.com/v1/dummy_data?clinical_code=44054006

* It will work in a browser but use of an API runner application like [Postman](https://www.getpostman.com/) is highly recommended.
* You must send a `clinical_code` of `44054006` which is a way of telling the API that the data is for the [SNOMED-CT](https://en.wikipedia.org/wiki/SNOMED_CT) diagnosis of `Diabetes mellitus type 2 (disorder)`. The idea is that the API will eventually support other diagnoses, specified by SNOMED_CT code.
* By default, the API uses some defaults for the mean and standard deviation of the tests, which I have obtained from anonymised time-series data. For further details on this, see the [datasets](../../datasets) directory, and also the source code of the [`DummyDataController`](../../app/controllers/dummy_data_controller.rb)
* You can override the defaults by passing in parameters in the URL query string:
  - hba1c_mean
  - hba1c_standard_deviation
  - rbg_mean
  - rbg_standard_deviation
  - rbg_number_in_series
  - hba1c_number_in_series

### Roadmap
* Add more clinical conditions and relevant, plausible clinical ransomly generated observation data for them.
* Clinically assure that using this test data is at least as safe as making up test data 'manually'.

### Contributing
* Collaborations are welcome, please see the [Contributing section of the main repo's README](../../README.md)
