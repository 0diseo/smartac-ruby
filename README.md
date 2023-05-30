# Summary

We have a simple backend service that works with SmartAC air conditioning units installed in hundreds of thousands of homes around the country.

The devices can register themselves and then immediately start sending data about their environments.

# Tasks

The tasks are designed to be done sequentially make sure to do so:

* Open a Github pull requests (PR) for each task using meaningful commits.
* Feel free to merge the PRs, the team will review main branch along with closed PRs at the end.
* The specification of the API is outlined below and should be used as a reference to implement the tasks.

## Task 1

Implement the `Api::V1::DevicesController#create` action to register a new device. Request and response details should follow the API specification below.

For the JWT generation have a look at `lib/json_web_token.rb`.

## Task 2

Record readings for a device in bulk, for the `/api/v1/readings` endpoint. Allow for multiple readings to be sent for one API call, following the API specification.

## Task 3

Implement a new `api/v1/devices/:id` endpoint to validate the status of the JWT used in the request. Also, add documentation for this new endpoint in the section below.

You can leverage the code in the `authenticate_api` method for this purpose.

## Task 4

Enhance the `app/views/devices/show.html.haml` page to show charts for temperature, humidity and carbon monoxide values.

The gem https://chartkick.com is already installed, so you can leverage it to create the charts if you prefer.

## Task 5

By this point you might have already identified several refactors you would like to perform, this task is for you to convert this application into a project that follows best practices and can be easily extendable by a team that will work on it in the future.

Take ownership of the code, fix any existing problems, and make it a solid base for the team to work from in the future. Feel free to change anything that makes sense; for example if you don't like the repository layer, then do something about it!

# Device API specification

## Registration

Registering a device is required prior to data collection.  Not only does the
process record the device identification in the data store, but it also returns
a Bearer token to the device that must be provided in future data reporting
calls.

**URL**: `/api/v1/devices`

**Method**: `POST`

**Body**:
```json
{
    "device": {
        "serial_number": "123456",
        "firmware_version": "v1.0.0"
    }
}
```

**Headers**:
```json
{ "Authorization": "Key SERIALLAIRES" }
```

The `Authoriation` header value must be the serial number of the device concatenated with its reverse string. Eg: If the serial number is `"ABC123"` the header value should be `"Key ABC123321CBA"`.

### Successful Response

**Code**: `200 OK`

**Payload**:
```json
{
    "device": {
      "id": 6,
      "serial_number": "123456",
      "firmware_version": "v1.0.0",
    },
    "token": "ABC123DEF456"
}
```

The token returned above will need to be cached by the client for use in the
sensor reporting process below.

### Error Responses

#### Bad Authorization Key

**Code**: `401 Unauthorized`

### Invalid/Missing Serial Number

**Code**: `422 Unprocessable Entity`

## Sensor Reporting

Sensor readings are reported to the `readings` endpoint.  The device will be
determined by the token passed in the `Authorization` header, so there is no
need to supply any id in the URL.  Up to 500 readings can be reported in a
single API call, making catch-up much simpler.  The following sensor readings
are recognized by the system:

| Sensor Name | Value |
| ----------- | ------- |
| temperature | Current ambient temperature (in Celcius) |
| humidity | Relative humidity (as a percentage) |
| co_level | PPM reading for Carbon Monoxide |
| health | Current health status of the unit|

**URL**: `/api/v1/readings`

**Method**: `POST`

**Body**:
```json
{
    "readings": [
        { "temperature": "22.3", "humidity": "53.7", "co_level": "2.812", "health": "ok", "timestamp": "2020-09-03T12:25:13.231Z" },
        { "temperature": "25.9", "humidity": "53.8", "co_level": "2.413", "health": "needs_service", "timestamp": "2020-09-03T12:26:12.428Z" }
    ]
}
```

**Headers**:
```json
{ "Authorization": "Bearer <Token from Registration>" }
```

### Successful Response

**Code**: `204 No Content`

### Error Response

**Code**: `422 Unprocessable Entity`

**Payload**:
```json
[
  {
    "timestamp": "2020-09-03T12:25:13.231Z",
    "error": {
      "temperature": [
        "can't be blank"
      ]
    }
  },
  {
    "timestamp": "2020-09-03T12:26:12.428Z",
    "error": {
      "temperature": [
        "can't be blank"
      ]
    }
  }
]
```
the error response return only the invalid reading with the timestamp like id to identify them, and the errors 
(right now it does not return error, the example was a hardcode error I force in the model)

## validate the status of the JWT


Validate the status of the JWT tokens is required for the devices, because the 
tokens have a life cycle of 24 hour, and the device should know if the token need
to bee restore


**URL**: `/api/v1/devices/:id`

**Method**: `GET`

**Headers**:
```json
{ "Token": "bearer yJhbGciOiJIUzI1NiJ9.eyJp" }
```
The `Token` should be the current token that is going to be validate

### Successful Response

**Code**: `200 OK`

**Payload**:
```json
{
  "token_valid": true
}
```

If the token is valid is going to return a json with `token_valid` value of true

### Error Responses

#### Token expiration or incorrect id and token

**Code**: `422 Unauthorized`

**Payload**:
```json
{
  "token_valid": false
}
```
if the token is expired or the id is not correspondig to the token it will return `token_valid` with value of true

# Development

Currently, development is orchestrated using `docker-compose`.  To start the
development server:

```sh
$ docker-compose up server
```

This will also start a PostgreSQL container to store site data. 

Also, you will need to build the assets if this is your first time booting the app. After running the command above, do

```sh
$ docker exec smart_ac_app bundle exec rake assets:precompile
```

Similarly, a Rails console can also be started in a container:

```sh
$ docker-compose run console
```

# Testing

The test suite can also be run via `docker-compose`.  For performance reasons,
    it is advised to start the spring container in the background:

```sh
$ docker-compose up -d spring
```

Then, just run the test suite inside a purpose-built container:

```sh
$ docker-compose run test rspec
```

Rubocop can be run similarly:

```sh
$ docker-compose run test rubocop
```

# Demo

A seeded user exists with the following credentials:

**Email**: admin@example.com

**Password**: administrator
