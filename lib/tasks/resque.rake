require 'resque/tasks'

task 'resque:setup' => :environment

require 'resque_scheduler/tasks'
