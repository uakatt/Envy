module Envestigators
  class AccountsCount
    EnvestigateNew = "/envestigate/new"

    @queue = :webdriver_queue

    def self.perform(environment_id)
      environment = Environment.find(environment_id)
      time = Time.now
      screenshot_file_name = "%.3f_#{environment.code.gsub(/\s/, '-')}_accounts_count.png" % time.to_f
      screenshot_file_path = File.join(Envy.driver.screenshots_dir, screenshot_file_name)

      Envy.driver.load(environment.code, environment.url)
      accounts_count = Envy.driver.accounts_count(:chartOfAccountsCode => 'UA', :accountName => 'A%')
      span_id = Envy.driver.wrap_with_span("//div[@id='lookup']/../text()[4]")
      results_box = Envy.driver.find_element(:id, span_id)
      Envy.driver.screenshot_element(results_box, screenshot_file_name, 108)

      #PrivatePub.publish_to(EnvestigateNew, update_results_with(environment, "#{accounts_count} Accounts (under 'UA', and named 'A%')"))
      PrivatePub.publish_to(EnvestigateNew,
                           {:env => environment.code.gsub(/ /, '-'),
                            :envestigation => 'accounts-count',
                            :message => "#{accounts_count} Accounts (under 'UA', and named 'A%')",
                            :screenshot => screenshot_file_name})
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

