# Running Ohana API on your computer

## Install Prerequisites

Before you can run Ohana API, you'll need to have the following software
packages installed on your computer: Git, Ruby 2.1+, RVM, and Postgres.
If you're on a Linux machine, you'll also need Node.js and libpq-dev.

If you already have all of the prerequisites installed, you can go straight
to the [Ohana Installation](#install-ohana-api). Otherwise, there are two ways
you can install the tools:

1. Use our Vagrant [virtual machine][dev-box], which has everything set up for
you. This is the recommended method for Windows users.

[dev-box]: https://github.com/codeforamerica/ohana-api-dev-box

2. Install everything manually: [Build tools][build-tools], [Ruby with RVM][ruby],
[Postgres][postgres], and [Node.js][node] (Linux only).

[build-tools]: https://github.com/codeforamerica/howto/blob/master/Build-Tools.md
[ruby]: https://github.com/codeforamerica/howto/blob/master/Ruby.md
[postgres]: https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md
[node]: https://github.com/codeforamerica/howto/blob/master/Node.js.md


## Install Ohana API

### Fork and clone

[Fork this repository to your GitHub account][fork].

Clone it on your computer and navigate to the project's directory:

    git clone https://github.com/<your GitHub username>/ohana-api.git && cd ohana-api

[fork]: http://help.github.com/fork-a-repo/

### Install the dependencies and populate the database with sample data:

    script/bootstrap

_Note: Installation and preparation can take several minutes to complete!_

### Set up the environment variables & customizable settings

Inside the `config` folder, you will find a file named `application.example.yml`.
Copy its contents to a new file called `application.yml`.

Inside the `config` folder, you will also find a file called `settings.yml`.
In that file, there are 3 variables you can customize. Please read through the
instructions in that file carefully.

### Run the app

Start the app locally on port 8080:

    rails s -p 8080

If for some reason, you can't run on port 8080, make sure you update
`API_BASE_URL` and `API_BASE_HOST` in `config/application.yml` if you change
the port number. You'll also need to update the port number in
`OHANA_API_ENDPOINT` in your local [Admin Interface][admin] if it's pointing to
your local API.

[admin]: https://github.com/codeforamerica/ohana-api-admin

### Verify the app is returning JSON

[http://localhost:8080/api/locations](http://localhost:8080/api/locations)

[http://localhost:8080/api/search?keyword=food](http://localhost:8080/api/search?keyword=food)

We recommend the [JSONView][jsonview] Google Chrome extension for formatting
the JSON response so it is easier to read in the browser.

[jsonview]: https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc

### Uploading and validating your own data

- [Prepare your data][prepare] in a format compatible with Ohana API.

- Place your JSON file in the `data` folder.

- Open `lib/tasks/setup_db.rake`, and replace `sample_data.json` on line 9
with your JSON file.

- Run `script/reset` from the command line.

If the script fails because of `Geocoder::OverQueryLimitError`, try slowing
down the script by uncommenting line 32 in `setup_db.rake `. Alternatively,
use a different geocoding service that allows more requests per second.
See the [geocoding configuration][geocode] section in the Wiki for more details.

If any locations contain invalid data, the script will output the following line:
```
Some locations failed to load. Check data/invalid_records.json.
```
Check `data/invalid_records.json` to see which fields need to be fixed.
Each line will identify the location by its name and will specify the invalid
fields. For example:
```
{"Redwood City Free Medical Clinic":{"errors":{"contacts.name":["can't be blank for Contact"]}}}
```
At this point, your local database is populated with all of the locations from your
JSON file, except for the invalid ones. Therefore, to avoid populating the database
and geocoding the addresses all over again, follow these steps:

1. For each location in `invalid_records.json`, find the corresponding location
in your original JSON file, then copy and paste that location (from your
original JSON file, not `invalid_records.json`) into a new `.json` file.

2. Fix the invalid data in this new file.

3. Set this new file on line 9 of `setup_db.rake`.

4. Delete `invalid_records.json`. The script appends to it, so you want to
delete it before running the script to start fresh each time.

5. Run `rake load_data`

6. If the script outputs `Some locations failed to load.`, repeat steps 1 - 5
until your data is clean.

[prepare]: https://github.com/codeforamerica/ohana-api/wiki/Populating-the-Postgres-database-from-a-JSON-file
[geocode]: https://github.com/codeforamerica/ohana-api/wiki/How-to-deploy-the-Ohana-API-to-your-Heroku-account#geocoding-configuration

### Export the database

Once your data is clean, it's a good idea to save a copy of it to make it easy
and much faster to import, whether on your local machine, or on Heroku.
Run this command to export the database:

```
script/export
```
This will create a filed called `ohana_api_development.dump` in the data folder.

### Import the database locally

To reset your local database and populate it again with your clean data:
```
script/import
```

### User authentication (for the developer portal)

The app automatically sets up users you can [sign in][sign_in] with.
Their username and password are stored in [db/seeds.rb][seeds].

[sign_in]: http://localhost:8080/users/sign_in
[seeds]: https://github.com/codeforamerica/ohana-api/blob/master/db/seeds.rb

