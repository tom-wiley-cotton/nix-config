# To add a new database to this config

1. `cp` an example file, say `atuin.nix` and change the user and database name
2. Create a new scram encoded database password agenix file in `secrets/`
   1. Create entries in `secrets.nix`
   2. `agenix -e <service>-database.nix`
   3. Generate the scram password by using: [this tool](https://supercaracal.github.io/scram-sha-256/) entering the database password
3. Create a new "plain-text" agenix secret, in whatever format the service needs. It might be a url, `KEY=value`, or just the password.
4. Add the agenix secret(s) to `secrets/default.nix`
   1. Ensure the database password secret is owned by `postgresql` and the "raw" password is owned by client process user
5. Add the postrgresql config to the host, probably `nas-01`

