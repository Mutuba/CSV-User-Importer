# README

# User Upload App

## Description

- The User Upload App is a Ruby on Rails application that allows users to upload CSV files containing user data. It validates and processes the data, creating user records in the database. Passwords are validated according to strict criteria to ensure they are strong.

## Features

User Model: Validates user data with strong password requirements.
CSV Upload: Upload and process CSV files containing user names and passwords.
Cloud Storage: Utilizes Cloudinary for file storage and retrieval.
Background Processing: Handles CSV processing in the background using Sidekiq.
Real-time Updates: Provides real-time progress updates and results using Turbo Streams.
StimulusJS: Manages form interactions and dynamic updates on the front end (views).

## Technologies

- Ruby on Rails 7
- Cloudinary for file storage
- Sidekiq for background job processing
- Turbo Streams for real-time updates
- StimulusJS for frontend behavior
- PostgreSQL for database management

## Setup

- Prerequisites
- Ruby 3.2.2
- Rails 7.1.3
- PostgreSQL

## Ruby and Rails installation

- RVM

`rvm install 3.2.2`

`rvm use 3.2.2`

- Rbenv

`rbenv install 3.2.2`

- Bundler provides a consistent environment for Ruby projects by tracking and installing
  the needed gems and versions. I recommend bundler version 2.0.2. To install:

- You need Rails. The rails version being used is rails version 7

- To install:

`gem install rails -v '~> 7'`

## Installation

- Clone the repository:

- With SSH

`git clone https://github.com/your-username/CSV-User-Importer.git`

`cd CSV-User-Importer`

- With HTTPS

`https://github.com/Mutuba/CSV-User-Importer.git`

- Install Ruby gems:

`bundle install`

## Set up the database:

```ruby
rails db:create
rails db:migrate
```

- To run tests, run the following command
  `rspec`

## Configure Cloudinary:

You can sign up for a Cloudinary account and get your credentials.

Create a .env file in the root directory and add your Cloudinary credentials:

```ruby
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

## Start the Rails server:

`rails server`

## Start Sidekiq (in a separate terminal):

`bundle exec sidekiq`

## Usage

- Visit the homepage:

- Open your web browser and navigate to http://localhost:3000/users.

## Upload a CSV file:

- Click the "Choose File" button to select a CSV file containing user data.
- Click the "Upload" button to submit the file.

## View results:

After uploading, you will see progress updates and results. Successful user creations and any errors will be displayed on the page.

## CSV File Format

The CSV file should have the following format:

```ruby
name,password
John Doe,Password123
Jane Smith,StrongPass1
```

name: The user's name (required).
password: The user's password (required).

## Validation Rules

# Password

- Length: 10 to 16 characters.
- Must include at least one lowercase letter, one uppercase letter, and one digit.
- Cannot have three consecutive repeating characters.

## Contributing

- Contributions are welcome! Please open an issue or submit a pull request with any improvements or bug fixes.

## License

-This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments

- Cloudinary for image and file storage.
- Sidekiq for background job processing.
- Turbo Rails for real-time updates.
- StimulusJS for frontend interactions.
- activerecord-import gem for bulk import and streaming updates, fetching created and failed records with error messages. [link](https://github.com/zdennis/activerecord-import)
