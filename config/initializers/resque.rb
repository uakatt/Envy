require 'resque_scheduler'
Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")

Resque.before_first_fork do
  Envy.driver
  puts "Loaded WebDriver"
end
