# Voter record change logs

Voter Record Change Logs (VRCLs) are the basis for a voter registration change notification service to voters.

Notifications are published to an sns toppic with the following schema:

```json
{
  "attribute_changed":"voter field that was updated",
  "current_state":"new state of the voter field",
  "uid":"uuid of the voter",
  "previous_state":"previous state of the voter field",
  "phone":"voter phone number",
  "email":"voter email address"
}
```
## Documentation
[API documentation can be found here](https://hermes.demo.trustthevote.org/api-docs/index.html)

## Basic architecture

This application exposes an api that allows users to upload a bulk csv of voter information. That voter information is stored in a database table (postgres). The [paper-trail](https://github.com/paper-trail-gem/paper_trail) gem is used to automatically calculate changes on that table.

On import for any models that are freshly created or updated a third party service is called (through a client wrapper) to get the voter status. This voter status is then saved on the model.

Periodically the third party service is queried to ensure that all existing user information is correct. Any changes are amalgamated into an email and sent to the administrator.

Data about voters is exposed via a restful api.

For now a simple encrypted key is used for api access to this application.

## Voter registration status service

We have selected [Alloy.us](https://docs.alloy.us/api/) as a data partner to provide statuses for the voters that we track. Voter records must be recorded in Alloy's data, before their status can be queried; therefore, each time a voter record is imported into Hermes, Hermes adds that voter record to the list of records that Alloy will include in query results. 

All polls are preempted by a data freshness query to limit api traffic.


## Developing

dependencies: postgres, rails 6.0, ruby 2.6

clone the repo: `git clone https://github.com/not_sure_yet/hermes`
bundle: `bundle install`

set up the database: `rake db:setup`

run the server: `rails s`

run the tests: `rspec spec`
