$LOAD_PATH << File.dirname(File.expand_path(__FILE__))

require 'forwardable'
require 'selenium-webdriver'
require 'headless'

module Envy
end

require 'envy/web_driver'
