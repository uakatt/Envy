class Envy::WebDriver
  attr_reader :driver
  attr_accessor :headless, :is_headless, :pause_time

  extend Forwardable
  def_delegators :@driver, :close, :execute_script, :navigate, :quit, :switch_to,
                           :window_handle, :window_handles

  def initialize(options={})
    @pause_time =  options[:pause_time] || 0.3
    @is_headless = true unless options.has_key? :is_headless and options[:is_headless]
    @wait_time =   options[:wait_time] || 8

    if @is_headless
      @headless = Headless.new
      @headless.start
    end

    @driver = Selenium::WebDriver.for :firefox, :profile => @profile
  end

  def build_number
    @driver.find_element(:id, 'build').text =~ /(\d.*) \(Oracle9i\)/
    $1
  end
end
