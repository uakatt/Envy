module Envestigators
  class BuildNumber
    EnvestigateNew = "/envestigate/new"

    @queue = :webdriver_queue

    def self.perform(environment_id)
      environment = Environment.find(environment_id)
      time = Time.now
      screenshot_file_name = "%.3f_#{environment.code.gsub(/\s/, '-')}_build_number.png" % time.to_f
      screenshot_file_path = File.join(Envy.driver.screenshots_dir, screenshot_file_name)

      Envy.driver.load(environment.code, environment.url)
      build_number = Envy.driver.build_number
      Envy.driver.screenshot_build_number(screenshot_file_name)

      PrivatePub.publish_to(EnvestigateNew,
                           {:env => environment.code.gsub(/ /, '-'),
                            :envestigation => 'build-number',
                            :message => "Build Number: #{build_number}",
                            :screenshot => screenshot_file_name})
    rescue Selenium::WebDriver::Error::NoSuchElementError
      Envy.driver.screenshot()
      PrivatePub.publish_to(EnvestigateNew,
                           {:env => environment.code.gsub(/ /, '-'),
                            :envestigation => 'build-number',
                            :message => "Error. :( I coulndn't find it.",
                            :screenshot => 'screenshot.png',
                            :add_class => 'error'})
    end
  end
end

