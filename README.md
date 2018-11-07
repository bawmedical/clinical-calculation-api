# Clinical Calculator API

A Ruby on Rails application which presents a range of clinical calculations as a REST API

## IMPORTANT - DISCLAIMER
This API is a work in progress and is offered as an open source project as-is, without any warranty. It is expressly not for live use in clinical systems with real patients.

### Why use an API for this?
* avoids the need for the calculations to be implemented locally in applications, which can result in errors
* calculations can be openly peer-reviewed and clinically assured
* MHRA registration as a medical device can be done once at the API level
* clinicians can contribute knowledge to a single

### Background
* Clinical calculations are tools which medical professionals use to help make decisions. Many of them are available in web page form on sites such as [MDCalc](https://www.mdcalc.com/)
* However a webpage is not something that a computer program can use, so in order to embed these calculations inside clinical systems we need an API (Application Programming Interface) which computers CAN use - they can send a structured data 'question' to the API and receive a machine-readable structured data 'answer'.
* Incredibly, not a *single* one of the currently used GP clinical systems (the software your GP uses in their practice) can actually calculate ALL the required calculations that doctors need. When new calculations are published there is often a lag of months or years before system suppliers implement the change, despite most of the algorithms being openly published and in some cases with an open source reference implementation!
* This effectively prevents doctors from using the correct/best tools for managing patients in the NHS.
* A particularly absent calculation in current UK GP systems is calculation of Height, Weight, and BMI Centiles, which are critical for the management of a wide range of childhood conditions including childhood obesity, which is an increasingly important problem.
* The Clinical Calculation API aims to remedy this situation by providing an open API which can be integrated with to obtain reliable clinical calculations for your app.

### Implementation
* each calculation is a single Rails controller with a `calculate` action containing the calculation code
* some calculations make use of an external library such as an open source C implementation of the calculation

### Installation for development
* `git clone` this repo
* cd into the repo directory
* `bundle install` to install all dependencies
* `rails s` to start the development server
* possibly the simplest way to play with the API is to use a REST client such as Postman https://www.getpostman.com/ to send GET requests with the data fields as part of the URL. We are aware that strict HTTP verb usage would suggest a POST with parameters, but we had some minor teething troubles with deployment of this to a remote server and therefore temporarily switched to GET+?urlparams.

### Roadmap
#### now
* at present the main plan is to get as many good quality clinical calculations added as possible
* we are keen to recruit developers and clinicians to help with the project
* set the API up with an API management layer
* create Swagger documentation for the API
* implement comprehensive testing for every endpoint
#### medium term
* add support for using terminologies such as SNOMED-CT or other older terminologies in both the request and the response
* continuous integration
* refactor out groups of calculations into their own Ruby gems so they could be reused in other code
* reviewers can 'sign off' their clinical safety review using a cryptographic signature pair.
* consider extended and/or testing in a separate API client
#### long term
* register with the MHRA as a medical device (anything which provides decision support like this is really a device)
* have the API being used by real-life clinical systems

### Getting Involved
* we are keen to have clinicians 'adopt' a calculation and become its 'owner' - as an owner of a calculation you will co-ordinate clinical review of the calculation (via GitHub issues, pull requests etc), and record the names of clinical reviewers
* we are also keen to recruit developers who want to work on a project that can save lives, reduce suffering, and improve quality of life for people around the world.

### About Open Health Hub CIC
* Open Health Hub CIC is a non-profit organisation which is dedicated to promoting open source in healthcare, and developing open source healthcare applications, tools, and knowledgebase.
* We are incorporated in the UK as a Community Interest Company number 08266350
* Join us at our forum https://www.openhealthhub.org/

## License
* GNU Affero GPL v3 license
