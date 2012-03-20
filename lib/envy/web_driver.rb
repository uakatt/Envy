class Envy::WebDriver
  attr_reader :driver
  attr_accessor :headless, :is_headless, :password, :pause_time, :username

  extend Forwardable
  def_delegators :@driver, :close, :execute_script, :navigate, :switch_to,
                           :window_handle, :window_handles

  include Envy::KfsBehaviors

  def initialize(options={})
    @pause_time  = options[:pause_time] || 0.3
    @is_headless = true unless options.has_key? :is_headless and (not options[:is_headless])
    #@is_headless = false
    @wait_time   = options[:wait_time] || 8
    @logger      = options[:logger] || nil

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

  # Navigate to an environment. `code` should be the code defined for an application in the
  # Envy webapp, eg "kfs dev". If this environment uses a non-standard URL, like "kfs sup",
  # then you need to additionally supply the url, like
  # "https://financialsup.uaccess.arizona.edu"
  def load(code, url=nil)
    if url.nil? or url.empty?
      if code =~ /(\w+)[ \-](\w+)/
        app = $1.downcase
        name = $2.downcase
        app = 'kra' if app == 'kc'
        url = "https://#{app[0,2]}-#{name}.mosaic.arizona.edu/#{app}-#{name}"
      else
        raise ArgumentError.new("environment must look something like 'kfs-dev' or 'kc-stg'")
      end
    end
    @logger.info "Loading #{url}..." if @logger
    @driver.navigate.to url
    webauth_login if webauth_login_page?
  end

  def quit
    @driver.quit
    @headless.destroy if @is_headless
  end

  def select_frame(id)
    @driver.switch_to.frame(id)
  end

  def webauth_login
    if @username.nil? or @password.nil?
      raise WebauthUsernameOrPasswordMissing.new("No username or password defined!")
    end

    @driver.find_element(:id, 'username').send_keys(@username)
    @driver.find_element(:id, 'password').send_keys(@password)
    @driver.find_element(:css, '#fm1 .btn-submit').click
  end

  def webauth_login_page?
    @driver.find_element(:css, 'input#username.required')
  rescue Selenium::WebDriver::Error::NoSuchElementError
    nil
  end
end
