class Environment < ActiveRecord::Base
  has_many :melodie_snapshots
  has_many :envestigations

  def default_url
    if code =~ /(\w+)[ \-](\w+)/
      app = $1.downcase
      name = $2.downcase
      app = 'kra' if app == 'kc'
      "https://#{app[0,2]}-#{name}.mosaic.arizona.edu/#{app}-#{name}"
    end
  end

  def latest_melodie_snapshot
    melodie_snapshots.order(:taken_at).last
  end

  def latest_melodie_snapshots
    latest = melodie_snapshots.order(:taken_at).last
    return nil if latest.nil?

    melodie_snapshots.where(:taken_at => latest.taken_at)
  end

  def envestigate_build_number
    time = Time.now
    Envy.driver.load(code, url)
    build_number = Envy.driver.build_number
    screenshot_file_name = "%.3f_#{code.gsub(/\s/, '-')}_build_number.png" % time.to_f
    screenshot_file_path = File.join(Envy.driver.screenshots_dir, screenshot_file_name)
    Envy.driver.screenshot_build_number(screenshot_file_name)

    envestigation = Envestigation.create(:environment => self,
                         :time => time,
                         :title => 'Build Number',
                         :text => build_number)
    screenshot = Screenshot.create(:envestigation => envestigation,
                                   :time => time,
                                   :image => File.open(screenshot_file_path, 'r'),
                                   :title => 'Build Number')
    return envestigation
  rescue Selenium::WebDriver::Error::NoSuchElementError => exception
    envestigation = Envestigation.create(:environment => self,
                         :time => Time.now,
                         :title => 'Build Number',
                         :text => "Error. :( I couldn't find it.",
                         :exception => exception)
    return envestigation
  rescue Timeout::Error => exception
    envestigation = Envestigation.create(:environment => self,
                         :time => Time.now,
                         :title => 'Build Number',
                         :text => "Error. :( Timeout.",
                         :exception => exception)
    return envestigation
  rescue StandardError => exception
    envestigation = Envestigation.create(:environment => self,
                         :time => Time.now,
                         :title => 'Build Number',
                         :text => "Error. :( #{exception.message}",
                         :exception => exception)
    return envestigation
  end
end
