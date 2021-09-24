require "bundler"
Bundler.require
require_all "lib"

# Establish connection with the database through database.yml
ActiveRecord::Base.establish_connection(:development)

# Avoid undesired outputs on the terminal
ActiveRecord::Base.logger = nil
