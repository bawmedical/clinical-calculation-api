# clinical_calculator_api

presents a range of clinical calculations as a REST API, avoiding the need for the calculations to be implemented locally in applications.

###endpoints

* are dynamically added when the server detects a new calculator in the folder `calculators`, which can be (optionally) in its own subfolder to enable the logical grouping of any of your calculator's dependencies or libraries
* there's no need to restart the server, the changes will be autodetected at the point of the next REST request
* any variable that you add to the calculator prefixed by `field_` will automagically become a field that the API will accept as a request field.
* validation is also built in to each new calculation automatically, the server will respond with a meaningful error message telling you which fields are missing. In this way the API is semi-self-documenting.
* endpoints are also dynamically named according to the `name:<yourcalculatorname> property in your calculator's Ruby file, (or the default is to name the endpoint after the name of the calculator's Ruby file).
* endpoints are then available at [baseURL]/<yourcalculatorname>

###usage

* 

###installation
