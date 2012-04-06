class Envy::WebDriver
  attr_reader :driver
  attr_accessor :headless, :is_headless, :password, :pause_time, :screenshots_dir, :username

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
    @screenshots_dir = File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'public', 'system', 'screenshots')
    @tmp_screenshots_dir = File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'tmp', 'screenshots')
    FileUtils.mkdir @tmp_screenshots_dir unless File.exist? @tmp_screenshots_dir
    FileUtils.mkdir     @screenshots_dir unless File.exist?     @screenshots_dir
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
        raise ArgumentError.new("environment must look something like 'kfs-dev' or 'kc-stg', not '#{code}'")
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

  def screenshot(file_name='screenshot.png')
    @driver.save_screenshot(File.join(@screenshots_dir, file_name))
  end

  def screenshot_build_number(file_name = 'build.png')
    build = @driver.find_element(:id, 'build')
    screenshot_element(build, file_name, [5, 5, 8])
  end

  def screenshot_element(element, file_name, margin=0)
    x_position = element.location.x
    y_position = element.location.y
    width      = element.size.width
    height     = element.size.height

    margin_top = margin_right = margin_bottom = margin_left = 0
    case
    when margin.is_a?(Fixnum)
      margin_top = margin_right = margin_bottom = margin_left = margin
    when margin.is_a?(Array)
      case margin.size
      when 1
        margin_top = margin_right = margin_bottom = margin_left = margin[0]
      when 2
        margin_top = margin_bottom = margin[0]
        margin_right = margin_left = margin[1]
      when 3
        margin_top                 = margin[0]
        margin_right = margin_left = margin[1]
        margin_bottom              = margin[2]
      else
        margin_top    = margin[0]
        margin_right  = margin[1]
        margin_bottom = margin[2]
        margin_left   = margin[3]
      end
    end

    adj_x_position = x_position - margin_left
    adj_y_position = y_position - margin_top
    adj_x_position = [adj_x_position, 0].max
    adj_y_position = [adj_y_position, 0].max

    width += margin_right + (x_position - adj_x_position)
    height += margin_bottom + (y_position - adj_y_position)

    @driver.save_screenshot(File.join(@tmp_screenshots_dir, 'foo.png'))
    image = ChunkyPNG::Image.from_file(File.join(@tmp_screenshots_dir, 'foo.png'))
    image = image.crop adj_x_position, adj_y_position, width, height
    #image.to_image.save(File.join(@screenshots_dir, file_name), :fast_rgba)
    image.to_image.save(File.join(@screenshots_dir, file_name))
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
