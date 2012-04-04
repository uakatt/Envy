module Envestigators
  class BuildNumber
    EnvestigateNew = "/envestigate/new"

    @queue = :webdriver_queue

    def self.perform(environment_id)
      environment = Environment.find(environment_id)

      Envy.driver.load(environment.code, environment.url)
      build_number = Envy.driver.build_number
      Envy.driver.screenshot_build_number

      PrivatePub.publish_to(EnvestigateNew,
                           {:env => environment.code.gsub(/ /, '-'),
                            :envestigation => 'build-number',
                            :message => "Build Number: #{build_number}",
                            :screenshot => 'build.png'})
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

