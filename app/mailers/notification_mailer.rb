class NotificationMailer < ActionMailer::Base
  default from: 'srawlins@email.arizona.edu'

  def environments_notification
    @environments = Environment.all
    @envestigations = @environments.map { |env| env.envestigate_build_number }
    mail(:to => 'srawlins@email.arizona.edu', :subject => 'Environment Status')
  end

  helper_method :screenshot_tag
  def screenshot_tag(screenshot)
    "<img src=\"#{screenshot.image.url(:thumb)}\" title=\"#{screenshot.title + ', taken at '+screenshot.time.localtime.to_s}\" />"
  end
end
