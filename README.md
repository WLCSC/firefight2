Firefight
=========

Support ticket & inventory management

How To
------
* bundle install
* edit/create config/database.yml & config/app_config.yml
* edit config/initializers/setup_mail.rb with your mail server details
* change your security token in config/initializers/secret_token.rb
* rake db:setup
* Start the server, then log in to Firefight with an admin user
* Create your buildings, rooms, vendors, asset types, manufacturers, models and assets (in that order)
* Create at least 1 queue (we're using that to keep track of projects)
* Create security groups & give them permissions in your queue(s)
* Start using it!

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

