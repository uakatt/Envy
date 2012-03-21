module Envestigators
  class BuildNumber
    @queue = :webdriver_queue

    def self.perform(environment_id)
      environment = Environment.find(environment_id)

      #driver = Envy::WebDriver.new#(:logger => logger)
      #config = {}
      #Envy.parse_config_file_into(config)
      #driver.username = config[:username]
      #driver.password = config[:password]
      Envy.driver.load(environment.code, environment.url)
      build_number = Envy.driver.build_number

      PrivatePub.publish_to("/envestigate/new",
                            "$(\"##{environment.code.gsub(/ /, '-')}-results\")" +
                              ".removeClass('loading')" +
                              ".html(\"Build Number: #{build_number}\");")
    end
  end
end

