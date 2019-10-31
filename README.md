# Issue Tracker API

### Requirements
 * Ruby 2.6.5
 * PostgreSQL
 
The app was developed using PostgreSQL 11.4 but older versions should 
work fine as well.

### Setup
The `.env.sample` file contains default database credentials. If they do not 
match your environment, run the following command:
```
$ cp .env.sample .env
```

and configure  settings in `.env` file.

Run `$ bin/setup` to install all dependencies.

### Getting started

Start the server (the easiest way is to run `$ bin/server`).
Navigate to `/api-docs/index.html` for the documentation reference.
The documentation uses [Swagger](https://swagger.io/) engine and allows to send
request to the app right from the documentation page. 
Here is the recommended flow for interaction with the app:
1. Start with **Signup** section to create an author or a manager.
2. Navigate to **Login** section to authenticate the user you have just created
and receive an authorization token. Copy the value under the *token* key.
3. At the top right corner of the page, click **Authorize** button and paste the 
token you have received on the previous step. This allows you to interact with 
the Issues API. If you are using another client to interact with the app (e.g.
Postman), use the *Bearer token* type of request authorization or manually add
the token to headers by the *Authorization* key.
4. Navigate to the **Issues** section. Pay attention to the endpoint description
to get the idea of the parameters you are allowed and are not allowed to use as
an author/manager as well as the valid values for the parameters.

### Tests

Request specs are implemented with [rspec](https://github.com/rspec/rspec) and 
[rswag](https://github.com/rswag/rswag). Rspec examples aim to cover all 
available  endpoints and scenarios. Rswag examples only have minimal coverage
and are implemented for the sole purpose of generating an interactive
documentation reference.

### Code style

The app uses [rubocop](https://github.com/rubocop-hq/rubocop) and 
[rubocop-rspec](https://github.com/rubocop-hq/rubocop-rspec) to enforce ruby
code style guidelines.

### Continuous integration

The app uses [SemaphoreCI 2.0](https://semaphoreci.com/) for validating code
style, running security checks (with [brakeman](https://brakemanscanner.org/))
and enforcing tests integrity. The pipeline is configured in
`.semaphore/semaphore.yml`.

### Continuous deployment

SemaphoreCI is configured to deploy on each successful build on `master` branch. 
The application is deployed to 
[AWS Beanstalk Environment](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html).
You can find an url for the deployed application next to the repo description.
