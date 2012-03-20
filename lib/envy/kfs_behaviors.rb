module Envy::KfsBehaviors
  def accounts_count(criteria={})
    @driver.switch_to.default_content
    main_menu
    @driver.find_element(:link, 'Account').click
    select_frame "iframeportlet"
    criteria.each do |id, value|
      @driver.find_element(:css, "##{id}").send_keys value
    end
    @driver.find_element(:xpath, "//input[@title='search']").click
    wait = Selenium::WebDriver::Wait.new(:timeout => @wait_time*4)
    wait.until { @driver.find_element(:xpath, "//table[@id='row']/..") }  # text()[4] is fragile... eh.
    text = @driver.find_element(:xpath, "//table[@id='row']/..").text
    if text =~ /(\d+) items found/
      return $1
    else
      return nil
    end
  end

  def main_menu
    @driver.find_element(:link, 'Main Menu').click
    webauth_login if webauth_login_page?
  end
end
