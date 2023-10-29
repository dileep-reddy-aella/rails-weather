# Rails Weather

## Contents

- [Description](#description)
- [Structure](#Structure)
  - [HomeController](#homecontroller)
  - [LocationService](#locationservice)
  - [WeatherPresenter](#weatherpresenter)
  - [WeatherService](#weatherservice)
  - [MapsController](#mapscontroller)
  - [Sensitive Data Storage](#sensitive-data-storage)
  - [Styling](#styling)

## Description

A Weather Information site, which fetches the data by taking the address provided by the user

## Structure

Please find the below information about each file and it's responsbilities

### HomeController

`app/controllers/home_controller.rb`

The `HomeController` is responsible for managing the main logic of the application. It handles user requests and serves as the entry point.

- **Responsibilities**:
  - Fetch latitude, longitude and zipcode from Google Places Autocomplete API.
  - Determine the appropriate zipcode from latitude and longitude when Places API didn't return zipcode.
  - Cache weather data and fetch it from the cache if available.
  - Create and use a `WeatherPresenter` to format and present weather data.

- **Related Files**:
  - Uses LocationService to fetch zipcode from latitude and longitude
  - Uses WeatherService to fetch weather data.
  
### LocationService

`app/services/location_service.rb`

The `LocationService` is a service object which has individual single function methods for geolocation purposes.

- **Responsibilities**:
  -  Fetch zipcode using latitude and longitude.
  - Provide latitude and longitude for a given address.
  - Handle geocoding errors.

- **Dependencies**:
  - Uses Geocoder gem.

### WeatherService

`app/services/weather_service.rb`

The `WeatherService` is responsible for interacting with external weather data sources and fetching weather data.

- **Responsibilities**:
  - Fetch weather data for a given latitude and longitude.
  - Handle requests to Open Weather API.

- **Dependencies**:
  - Uses Open Weather API to fetch weather information.

### WeatherPresenter

`app/presenters/weather_presenter.rb`

The `WeatherPresenter` is responsible for formatting and presenting weather data.

- **Responsibilities**:
  - It's a interface for weather data, if in future Open Weather API response structure changes, then the client code (View) doesn't need to change.
  - Format location name.
  - Display today's date.
  - Format temperature, high and low temperatures.
  - Present weather descriptions.

### MapsController

`app/javascript/controllers/maps_controller.js`

The `MapsController` is a JavaScript Controller used to fetch Places information.

- **Reponsibilites**:
  - Call Places Autocomplete API from user input
  - Store the latitude, longitude and zipcode received from the response in the form fields

- **Dependencies**:
  - Uses Stimulus Framework to add interaction
### Sensitive Data Storage

The sensitive information in this projects scope, the `Google Maps API key` and `Open Weather API key` are stored in `Rails credentials` for security reasons.

So, if you'd like to run this project locally, you'll need the master key.

### Styling

TailwindCSS has been used for styling.
  - Hence, to run the app locally after, to run the server user `./bin/dev` instead of usual `rails server` for tailwind styling to come into action.



