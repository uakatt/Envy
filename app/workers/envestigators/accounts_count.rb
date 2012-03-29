module Envestigators
  class AccountsCount
    EnvestigateNew = "/envestigate/new"

    @queue = :webdriver_queue

    def self.perform(environment_id)
      environment = Environment.find(environment_id)

      Envy.driver.load(environment.code, environment.url)
      accounts_count = Envy.driver.accounts_count(:chartOfAccountsCode => 'UA', :accountName => 'A%')

      #PrivatePub.publish_to(EnvestigateNew, update_results_with(environment, "#{accounts_count} Accounts (under 'UA', and named 'A%')"))
      PrivatePub.publish_to(EnvestigateNew,
                           {:env => environment.code.gsub(/ /, '-'),
                            :envestigation => 'accounts-count',
                            :message => "#{accounts_count} Accounts (under 'UA', and named 'A%')",
                            :screenshot => "build.png"})
    rescue Selenium::WebDriver::Error::NoSuchElementError => e
      #PrivatePub.publish_to(EnvestigateNew, update_results_with(environment, "Error. :( I couldn't find it.", ".addClass('error')"))
      PrivatePub.publish_to(EnvestigateNew,
                           {:env => environment.code.gsub(/ /, '-'),
                            :envestigation => 'build-number',
                            :message => "Error. :( I coulndn't find it.",
                            :add_class => 'error'})
    end
  end
end

