# README

This is a simple webapp that allows you to check for the current temperature of your address. It implements a caching 
system that will store results on a zipcode basis to limit api requests and to speed up processes. **Should your request
be pulled from the cache you will see a notation informing you of it.**

## Setup

To be able to view and interact with the application locally complete the following steps:

1) In your terminal cd into the Directory you wish to have this project live.
2) Enter one of the following commands, either: `git clone git@github.com:jdconrad89/forcaster.git` (if you have SSH setup) or `git clone https://github.com/jdconrad89/forcaster.git`
3) Enter `cd forcaster` to navigate into the application
4) Enter `touch .env` to create the .env file.
5) Open the .env file and add `API_KEY=#{INSERT_API_KEY_GIVEN}`
6) Now run `rails s` in the terminal
7) Once the server is up and running open up a browser and enter `http://localhost:3000/` and you will be able to view the application and get your current weather


## Notes about the implementation.

- It utilizes a free version of the [WeatherStack API](https://weatherstack.com/documentation), so it is limited to 100 calls a month.
- As called out in `ForecastApi` 
  - The Units f flag in the url will return the temperature in Fahrenheit. We can always make this something that is
    selectable but would alter how we want to cache temperatures, more than likely just adding a Celsius/Fahrenheit notation
  - The first argument is currently shown as zipcode because the active query will be based on zipcode for now
      - The API take multiple different location based arguments (city, long/lat, etc.) so if we branch out to do it
        based on different locations we can either update the argument to be more generic or we can also make a base
        `ForecastApi` class that handles base logic and then make Child classes that inherit from it and would handle the different location
        type queries and any potential logic changes associated with it.
- There are other endpoints that are available in WeatherStack (Historical data, 7/14 day forecasts, etc.) but those are only available for paid plans. Similar 
  to the callout mentioned for different locations, if we want to implement those different endpoints we can create new child classes that handle the different endpoints/logic.
