# clinical_calculator_api

presents a range of clinical calculations as a REST API, avoiding the need for the calculations to be implemented locally in applications.

* incredibly, not a single one of the currently used GP clinical systems (the software your GP uses in their practice) can actually calculate ALL the required calculations that doctors need. When new calculations are published there is often a lag of months or years before system suppliers implement the change, despite most of the algorithms being openly published and in some cases with an open source C reference implementation!
* This effectively prevents doctors from using the correct/best tools for managing patients in the NHS.
* A particularly absent calculation in current GP systems is calculation of Height, Weight, and BMI Centiles, which are critical for the management of a wide range of childhood conditions including childhood obesity, which is an increasingly important problem. 

###endpoints

* are dynamically added when the server detects a new calculator in the folder `calculators`, which can be (optionally) in its own subfolder to enable the logical grouping of any of your calculator's dependencies or libraries
* there's no need to restart the server, the changes will be autodetected at the point of the next REST request
* any variable that you add to the calculator prefixed by `field_` will automagically become a field that the API will accept as a request field.
* validation is also built in to each new calculation automatically, the server will respond with a meaningful error message telling you which fields are missing. In this way the API is semi-self-documenting.
* endpoints are also dynamically named according to the `name:<yourcalculatorname>` property in your calculator's Ruby file, (or the default is to name the endpoint after the name of the calculator's Ruby file).
* endpoints are then available at `[baseURL]/<yourcalculatorname>`

###installation

* Clinical Calculator API is a Ruby application using the flexible and expansible Sinatra framework. The metaprogramming aspect of the addition of new calculators would have been hard to implement in many other languages which is why we chose the dynamic interpreted object-oriented language Ruby.

1. Install Ruby 2.2.1
2. clone the Git repo
3. cd into the repo directory
4. run `ruby server.rb` in the terminal

###usage

1. the server will be available at `localhost:4567` (Sinatra's default port)
6. endpoints are at `[baseURL]/<calculatorname>` - for example the centile endpoint is at `[baseURL]/centile`
7. The simplest way to play with the API is to use a REST client such as Postman https://www.getpostman.com/ to send GET requests with the data fields as part of the URL. We are aware that strict HTTP verb usage would suggest a POST with parameters, but we had some minor teething troubles with deployment of this to a remote server and therefore temporarily switched to GET+?urlparams.

###HTML5 client
* we have an (almost finished) testing client written in HTML5, which we are actively working on.
* however the primary usage of the API is to lower the bar to entry for developers wishing to use quality-assured clinical calculations, without having to implement the complex clinical calculations themselves and having to quality assure with expensive medical consultants in-house.
