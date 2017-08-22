Cheers
=======

### Setting up the database
Add a file .env.local to the root folder and configure DATABASE_URL to
match your environment (default: "DATABASE_URL:
postgresql://localhost:5432). Leave the database name out of the URL;
rails will fill it according to the database.yml config. Must have
postgresql installed.

### Downloading and importing a production backup from Heroku
https://gist.github.com/wrburgess/5528649
