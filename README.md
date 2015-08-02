# clinical_calculator_api

presents a range of clinical calculations as a REST API, avoiding the need for the calculations to be implemented locally in applications.

###endpoints

* are dynamically added when the server detects a new calculator in the folder `calculators`
* there's no need to restart the server
* any variable that you add to the calculator prefixed by `field_` will automagically become a field that the API will accept input to
* validation is also built in to each new calculation automatically, the server will respond with a meaningful error message telling you which fields are missing. In this way the API is semi-self-documenting

###usage

###installation
