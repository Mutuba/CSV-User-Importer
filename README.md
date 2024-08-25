# README

- User Import Monitor

- The application allows a user to upload a csv file with user details (name and password)
- Upon uploading the file, the application will process and return a list of created users and errors for records not created.

- This application uses Ruby version 3.2.2 To install, use rvm or rbenv.

- RVM

`rvm install 3.2.2`

`rvm use 3.2.2`

- Rbenv

`rbenv install 3.2.2`

- Bundler provides a consistent environment for Ruby projects by tracking and installing
  the exact gems and versions that are needed. I recommend bundler version 2.0.2. To install:

- You need Rails. The rails version being used is rails version 7

- To install:

`gem install rails -v '~> 7'`

\*To get up and running with the project locally, follow the following steps.

- Clone the app

- With SSH

`git@github.com:Mutuba/csv-test-app.git`

- With HTTPS

`https://github.com/Mutuba/csv-test-app.git`

- Move into the directory and install all the requirements.

- cd csv-test-app

- run `bundle install` to install application packages

- Run `rails db:create` to create a database for the application

- Run `rails db:migrate` to run database migrations and create database tables

- The application can be run by running the below command:-

`rails s` or `rails server`

- To run tests, run the following command
  `rspec`

Screenshots:
TBD
