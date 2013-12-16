# Load the rails application
require File.expand_path('../application', __FILE__)

APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")


# Initialize the rails application
Comparendo::Application.initialize!
require "#{Rails.root}/lib/tabs_on_rails/tabs/tabs_builder.rb"