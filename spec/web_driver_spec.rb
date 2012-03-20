require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib', 'envy')
require 'highline/import'

describe "Envy::WebDriver" do
  before(:all) do
    @driver = Envy::WebDriver.new
    config = {}
    Envy.parse_config_file_into(config)
    #@driver.username = $terminal.ask("NetID:  ")    { |q| q.echo = true }
    #@driver.password = $terminal.ask("Password:  ") { |q| q.echo = "*" }
    @driver.username = config[:username]
    @driver.password = config[:password]
  end

  after(:all) do
    @driver.quit
  end

  it "should find a build number in the home page" do
    @driver.navigate.to "https://kf-dev.mosaic.arizona.edu/kfs-dev"
    @driver.build_number.should =~ /\d+/
  end

  it "should find a build number in a KC home page" do
    #@driver.navigate.to "https://kr-dev.mosaic.arizona.edu/kra-dev"
    @driver.load 'kc-dev'
    @driver.build_number.should =~ /\d+/
  end

  it "should find the count of Accounts" do
    @driver.load 'kfs-dev'
    @driver.accounts_count(:chartOfAccountsCode => 'UA', :accountName => 'A%').should =~ /\d+/
  end
end
