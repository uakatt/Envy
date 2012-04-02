class Environment < ActiveRecord::Base
  has_many :melodie_snapshots

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
    Envy.driver.load(code, url)
    build_number = Envy.driver.build_number
    return build_number
  rescue Selenium::WebDriver::Error::NoSuchElementError
    return "Error. :( I coulndn't find it."
  end
end
