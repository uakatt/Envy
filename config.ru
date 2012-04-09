# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
#map '/envy/' || ActionController::Base.config.relative_url_root || '/' do
  run Envy::Application
#end
