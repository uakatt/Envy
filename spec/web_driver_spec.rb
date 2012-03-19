require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib', 'envy')

describe "Envy::WebDriver" do
  before(:all) do
    @driver = Envy::WebDriver.new
  end

  after(:all) do
    @driver.quit
  end

  it "should find a build number in the home page" do
    @driver.navigate.to "https://kf-dev.mosaic.arizona.edu/kfs-dev"
    @driver.build_number.should =~ /\d+/
  end
end
