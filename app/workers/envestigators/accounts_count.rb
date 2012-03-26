module Envestigators
  class AccountsCount
    EnvestigateNew = "/envestigate/new"

    @queue = :webdriver_queue

    def self.perform(environment_id)
      environment = Environment.find(environment_id)

      Envy.driver.load(environment.code, environment.url)
      accounts_count = Envy.driver.accounts_count(:chartOfAccountsCode => 'UA', :accountName => 'A%')

      PrivatePub.publish_to(EnvestigateNew, update_results_with(environment, "#{accounts_count} Accounts (under 'UA', and named 'A%')"))
    rescue Selenium::WebDriver::Error::NoSuchElementError => e
      PrivatePub.publish_to(EnvestigateNew, update_results_with(environment, "Error. :( I couldn't find it.", ".addClass('error')"))
    end

    def self.update_results_with(env, html, chain='')
      "$(\"##{env.code.gsub(/ /, '-')}-results\").removeClass('loading')" +
        ".html(\"#{html}\")#{chain};"  # TODO escape quotes or... whatever, js
    end
  end
end

