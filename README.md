# Cars R Us

## Task : Calculate vehicle tax cost

### Background
Cars R Us is an app that is used for listing vehicles that are for sale.


### Task Description
Every new vehicle that is sold, is sold with the vehicle tax included. Every time a vehicle is **created** or **updated** we 
want to calculate the tax that needs to be paid for the vehicle. This value should be stored in the 
record.

* Only new vehicles should have the tax calculated. Used vehicles are sold without any tax
* Tax rates can be hard coded into the app and changed by the developers whenever they change
* All new vehicles also have to pay £55 registration fee. Add this to any cost from the tax tables below
#### Non-commercial vehicles
* Tax rates for non-commercial vehicles are available here https://www.gov.uk/vehicle-tax-rate-tables (we are only interested in first payments)
* All diesel vehicles we handle conform to RDE2 standard. (I.e. ignore column "All other diesel cars (TC49)" in the tax table and use the first column for petrol/diesel)
* Electric/Hybrid are considered "Alternative fuel cars (TC59)"
#### Commercial vehicles
* Tax rates for commercial vehicles can be found here https://www.gov.uk/vehicle-tax-rate-tables/other-vehicle-tax-rates
* All of our commercial vehicles fall under "Light goods vehicles (TC39)"
* Electric or hybrid cost £0


### Current repo 
The repo consists of a (currently) very simple rails app with a single model 'Vehicle'.
(Other code in the model that is not relevant to this task has been removed for simplicity)
Vehicle contains 5 fields:
* stock_type: New / Used
* fuel_type: Petrol / Diesel / Hybrid / Electric
* co2: Amount of CO2 emmissions
* commercial_vehicle: boolean
* vehicle_tax: where you will store the calculated result

There is currently no UI to create or edit vehicles - but this is being developed by another team member, so the 
Controller and View code is outside of your scope.
Another team member is writing a background task that will import vehicles into Cars R Us.
Both of these team members will be relying on your work to automatically include the tax cost in the saved record. You are free to define (within reason)
how they should interact with vehicles to get the required behaviour, but any technique/interface should not surprise an experienced Rails developer.
 

### Non-functional requirements
Our tech lead has recently pointed out that our test run is taking over 2 minutes to run and he's requested that we 
write quicker tests. They said we should have a small amount of tests that touch the DB to ensure that part of the requirement works 
but most tests should not be touching the DB for this kind of functionality.

Another developer has mentioned that he feels the model is growing too large and so would like the absolute minimum code
inside the model.

### Setup

* Ruby version - 3.1.2
* Rails version - 7.0.3.1
* DB - sqlite
* Rspec

## Expectations
* Please clone the repo into your own github account
* Create a pull request with your work
* Some tests are expected, but 100% coverage is not a requirement
* We recommend time-boxing to 2 hours
* It is not necessary that the exercise is completed in full. We are not looking for perfect solution, simply a way to 
see how you structure your code. Feel free to add notes about how you would have completed, or enhanced the solution if
you had further time available

## Ben Golding Submission Notes
I had originally coded my solution with the logic for taxation contained within the Vehicle model, but this seemed to go against the non-functional requirements. To me, it seemed the best solution was to extract the taxation logic into a value object (which I called 'vehicle_tax.rb'). This is pretty new to me, so hopefully it's implemented OK - I suppose an alternative would've been to use concerns, i.e. "class Vehicle include Taxable ..." and "module Taggable extend ActiveSupport::Concern ...", but I thought this was worth giving a shot.

The intention of my approach is that anyone importing vehicle data can do so through ActiveRecord, and so long as they don't deliberately bypass callbacks in doing so, the vehicle_tax value should be populated automatically, given all other fields are provided.

Given more time I'd probably change the way testing is done by adding in the FactoryBot gem, and add more tests generally.

Overall I went over the suggested 2 hours, but that was mainly down to reading about value objects. I didn't time myself but imagine I'd be under without exploring this option.




