$LOAD_PATH << File.dirname(File.expand_path(__FILE__))

require 'forwardable'
require 'selenium-webdriver'
require 'headless'

module Envy
  ACCEPTED_OPTIONS = %w{username password}
  CONFIG_FILE = File.join(ENV['HOME'], '.envy')

  protected
  def self.error_on_world_readable_config_file(msg)
    $stderr.puts "Error: #{msg}"
    $stderr.puts "#{File.basename __FILE__} will not allow such a file. Make #{CONFIG_FILE} unreadable by others with:"
    $stderr.puts ""
    $stderr.puts "  chmod 700 #{CONFIG_FILE}"
    $stderr.puts ""
    $stderr.puts "Exiting."
    exit 2
  end

  def self.parse_config_file_into(hash)
    File.open(CONFIG_FILE, 'r') do |handle|
      while line=handle.gets
        parse_config_file_line(line, hash)
      end
    end
  end

  def self.parse_config_file_line(line, hash)
    return if line =~ /^\s*#/          # comment
    if line =~ /^\s*(.+?):\s*(.+)$/  # key: value
      key=$1; value=$2
      if not ACCEPTED_OPTIONS.include? key
        $stderr.puts "Warning: unrecognized option in #{CONFIG_FILE}: #{line}"
        return
      end

      if key=='password' and  File.world_readable? CONFIG_FILE
        error_on_world_readable_config_file "#{CONFIG_FILE} contains an email account password, but is readable by others!"
      end
      hash[key.to_sym] = value
    end
  end

  def self.driver
    return @@driver if class_variable_defined? '@@driver'

    @@driver = Envy::WebDriver.new#(:logger => logger)
    webdriver_config = {}
    parse_config_file_into(webdriver_config)
    @@driver.username = webdriver_config[:username]
    @@driver.password = webdriver_config[:password]

    return @@driver
  end
end

require 'envy/errors'
require 'envy/kfs_behaviors'
require 'envy/web_driver'
