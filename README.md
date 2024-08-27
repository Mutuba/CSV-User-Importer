# README

# User Upload App

## Description

- The User Upload App is a Ruby on Rails application that allows users to upload CSV files containing user data. It validates and processes the data, creating user records in the database. Passwords are validated according to strict criteria to ensure they are strong.

## Features

- User Model: Validates user data with strong password requirements.
- CSV Upload: Upload and process CSV files containing user names and passwords.
- Cloud Storage: Utilizes Cloudinary for file storage and retrieval.
- Background Processing: Handles CSV processing in the background using Sidekiq and Redis.
- Real-time Updates: Provides real-time progress updates and results using Turbo Streams.
- StimulusJS: Manages form interactions and dynamic updates on the front end (views).

## Technologies

- Ruby on Rails 7
- Cloudinary for file storage
- Sidekiq for background job processing
- Turbo Streams for real-time updates
- StimulusJS for frontend behavior
- PostgreSQL for data management
- Sidekiq for background job processing
- Redis for background job enqueuing

## Setup

- Prerequisites
- Ruby 3.2.2
- Rails 7.1.3
- PostgreSQL
- Sidekiq
- Redis

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

#### With SSH

`git clone https://github.com/your-username/CSV-User-Importer.git`

`cd CSV-User-Importer`

#### With HTTPS

`https://github.com/Mutuba/CSV-User-Importer.git`

- Install Ruby gems:

`bundle install`

## Set up the database:

```ruby
rails db:create
rails db:migrate
```

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

## Start Redis (in a separate terminal):

`redis-server`

## Start Sidekiq (in a separate terminal):

`bundle exec sidekiq`

## Usage

- Visit the homepage:

- Open your web browser and navigate to http://localhost:3000

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

## Screenshots

<img width="1440" alt="Screenshot 2024-08-26 at 09 53 20" src="https://github.com/user-attachments/assets/52271ee8-b087-464b-895e-73370a762806">

<img width="1436" alt="Screenshot 2024-08-26 at 09 53 41" src="https://github.com/user-attachments/assets/3c7c89de-9008-423f-904c-a3967232051d">

## Testing

## Running Tests

1. Run all tests

- `bundle exec rspec`

2. Run system tests

- `bundle exec rspec spec/system`

# Implementation and thoughts

## Folder structure

```ruby
app
├── assets
│ ├── config
│ │ └── manifest.js
│ ├── images
│ └── stylesheets
│ └── application.css
├── channels
│ └── application_cable
│ ├── channel.rb
│ └── connection.rb
├── controllers
│ ├── application_controller.rb
│ ├── concerns
│ └── users_controller.rb
├── helpers
│ ├── application_helper.rb
│ └── users_helper.rb
├── javascript
│ ├── application.js
│ └── controllers
│ ├── application.js
│ ├── index.js
│ └── upload_controller.js
├── jobs
│ ├── application_job.rb
│ └── users_csv_upload_job.rb
├── mailers
│ └── application_mailer.rb
├── models
│ ├── application_record.rb
│ ├── concerns
│ └── user.rb
├── services
│ ├── application_service.rb
│ ├── cloudinary_file_upload_service.rb
│ └── users_csv_import_service.rb
├── validators
│ └── strong_password_validator.rb
└── views
├── layouts
│ ├── \_alerts.html.erb
│ ├── \_navbar.html.erb
│ ├── application.html.erb
│ ├── mailer.html.erb
│ └── mailer.text.erb
└── users
├── \_modal_form.html.erb
├── \_progress.html.erb
├── \_upload_button.html.erb
├── \_user.html.erb
├── \_user_error.html.erb
├── \_users_error_table.html.erb
├── \_users_table.html.erb
└── index.html.erb
```

## Tests folder structure

```ruby
spec
├── controllers
│ └── users_controller_spec.rb
├── factories
│ └── users.rb
├── fixtures
│ ├── cassettes
│ │ ├── CsvFileUploadService
│ │ │ └── uploads_the_file_to_Cloudinary_and_enqueues_a_job.yml
│ │ └── File_Uploads
│ │ ├── allows_a_user_to_upload_a_file_and_see_results.yml
│ │ └── shows_errors_when_file_is_not_attached.yml
│ └── files
│ ├── invalid_users.csv
│ ├── users.csv
│ └── users.txt
├── jobs
│ └── users_csv_upload_job_spec.rb
├── models
│ └── user_spec.rb
├── rails_helper.rb
├── services
│ ├── cloudinary_file_upload_service_spec.rb
│ └── users_csv_import_service_spec.rb
├── spec_helper.rb
├── support
│ ├── factory_bot.rb
│ └── shoulda_matchers.rb
├── system
│ └── upload_spec.rb
└── validators
└── strong_password_validator_spec.rb
```

## Thought Process

### Choice of Cloudinary for File Uploads

#### Reasoning:

- File Storage Management: Storing files directly on Heroku or similar platforms can be problematic due to limitations in temporary storage. Cloudinary provides a robust cloud-based solution that handles file uploads and storage efficiently.

- Scalability: Cloudinary offers scalability to manage large volumes of file uploads and ensures consistent performance.

### Background Processing with Sidekiq

#### Reasoning:

- Asynchronous Processing: CSV file processing can be time-consuming, especially when dealing with large files. Using Sidekiq for background processing ensures that file uploads and user creation tasks do not block the main application thread, providing a better user experience.

- Retry Mechanism: Sidekiq’s built-in retry mechanism helps in handling temporary issues with file processing, improving the robustness of the application.

#### Potential Improvements:

- Streaming API: Integrating with a streaming API to handle large files more efficiently, allowing real-time processing and reducing memory usage during uploads.

- Advanced Retry Logic: A more granular retry mechanisms or exponential backoff strategies to handle transient errors more effectively.

### ActiveRecord Import Gem

#### Reasoning:

- Batch Processing: The activerecord-import gem facilitates efficient bulk imports by processing records in batches. This reduces the number of database transactions and improves performance compared to creating records one by one.

- Validation Handling: The gem supports validation failures, allowing us to identify and report issues with specific records without halting the entire import process.

### Potential Improvements:

- Custom Batch Size: Experiment with different batch sizes to find the optimal setting for performance and memory usage based on the specific needs of your application.

### Streaming Progress and Errors to the Template

#### Reasoning:

- User Experience: Providing real-time feedback on the progress of file uploads and user creation enhances the user experience by keeping users informed about the status of their requests. This approach helps users understand how much of the file has been processed and whether any errors occurred.

- Turbo Streams Integration: Turbo Streams enable seamless real-time updates without requiring full-page reloads. This technology allows us to push progress updates and error messages to the frontend dynamically, ensuring that users receive immediate feedback.

### Potential Improvements:

- Progress Bar Enhancements: Improve the granularity of progress updates by integrating a more detailed progress bar that provides finer-grained information.

- Error Handling UI: Develop a error handling UI to give users actionable insights into how to resolve issues with specific records

### Password Validation with ActiveRecord and Database Constraints

#### Reasoning:

- Comprehensive Validation: Implementing strong password validation at both the application and database levels ensures that all passwords meet security requirements. This dual-layer approach helps in maintaining data integrity and preventing invalid records from being saved.

- Database Constraints: Adding database constraints for password validation enforces rules at the database level, providing an additional layer of security that complements application-level validations.

### Potential Improvements:

- Enhanced Constraints: Consider additional constraints or rules for password complexity if further security enhancements are deemed necessary.

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
