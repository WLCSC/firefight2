
# Firefight

WLCSC's support ticket & inventory management system.

## How To Install

```sh
# Install dependencies
$ bundle install

# Create & update the values in config/database.yml & config/app_config.yml & config/resque.yml
$ cp config/database.yml.sample config/database.yml
$ cp config/app_config.yml.sample config/app_config.yml
$ cp config/resque.yml.sample config/resque.yml
# Create config/initializers/setup_mail.rb with your mail server details.
$ cp config/initializers/setup_mail.rb.sample config/initializers/setup_mail.rb
# change your security token in config/initializers/secret_token.rb

# Set up the database
$ bundle exec rake db:migrate

# Start the server
$ bundle exec rails server

# Now log in as admin user.
# Create buildings, rooms, vendors, asset types, manufacturers, models, and assets--in that order.
# Create at least 1 queue to keep track of projects.
# Create security groups and give them permissions in the queues.
# Start using!
```

This can use LDAP for user authentication as well.  LDAP-backed users don't exist inside Firefight until they log in.

    Firefight is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Firefight is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Firefight.  If not, see <http://www.gnu.org/licenses/>.
