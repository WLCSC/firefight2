
# Firefight

WLCSC's support ticket & inventory management system.

## How To Install

```sh
# Install dependencies
$ bundle install

# edit/create config/database.yml & config/app_config.yml & config/resque.yml
# edit/create config/initializers/setup_mail.rb with mail server details.
# change your security token in config/initializers/secret_token.rb

# Set up the database
# Note that you may need to prefix it with `bundle exec`; this will not cause problems.
$ rake db:migrate

# Start the server
$ rails server

# Now log in as admin user.
# Create buildings, rooms, vendors, asset types, manufacturers, models, and assets--in that order.
# Create at least 1 queue to keep track of projects.
# Create security groups and give them permissions in the queues.
# Start using!
```

This requires LDAP for user authentication.  Users don't exist inside Firefight until they log in.

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
