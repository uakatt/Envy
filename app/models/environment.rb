class Environment < ActiveRecord::Base
  has_many :melodie_snapshots
  has_many :envestigations

  def default_url
    if code =~ /(\w+)[ \-](\w+)/
      app = $1.downcase
      name = $2.downcase
      app = 'kra' if app == 'kc'
      "https://#{app[0,2]}-#{name}.mosaic.arizona.edu/#{app}-#{name}/"
    end
  end

  def java_memory_used_with_updated_at_title
    return "<span class='tiny-error'>no melodie snapshots</span>".html_safe if latest_melodie_snapshots.nil?

    results = []
    latest_melodie_snapshots.each do |snapshot|
      result = ''
      if snapshot.snapshot_errors
        text = "Melodie Error: " + snapshot.snapshot_errors.to_s
        result += "<span class='tiny-error'>#{text}</span>"
        results << result
        next
      end

      system_information = snapshot.system_information
      if system_information.nil?
        text = "No System Information..."
        result += "<span class='tiny-error'>#{text}</span>"
        results << result
        next
      end

      text = system_information[:java_memory_used].join(' out of ')

      if snapshot.taken_at
        result += "<span title=\"Taken at: #{snapshot.taken_at.localtime}\">#{text}</span>"
      else
        result += text
      end
      results << result
    end
    results.each(&:html_safe).join('<br />').html_safe
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
    screenshot_file_name = "%.3f_#{code.gsub(/\s/, '-')}_build_number.png" % time.to_f
    screenshot_file_path = File.join(Envy.driver.screenshots_dir, screenshot_file_name)
    Envy.driver.load(code, url)
    build_number = Envy.driver.build_number
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
    screenshot_file_name.sub!(/\.png$/, '_error.png')
    screenshot_file_path = File.join(Envy.driver.screenshots_dir, screenshot_file_name)
    Envy.driver.screenshot(screenshot_file_name)
    envestigation = Envestigation.create(:environment => self,
                         :time => Time.now,
                         :title => 'Build Number',
                         :text => "Error. :( I couldn't find it.",
                         :exception => exception)
    screenshot = Screenshot.create(:envestigation => envestigation,
                                   :time => time,
                                   :image => File.open(screenshot_file_path, 'r'),
                                   :title => 'Build Number Error')
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
