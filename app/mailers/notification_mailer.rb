class NotificationMailer < ActionMailer::Base
  default from: 'srawlins@email.arizona.edu'

  def environments_notification
    @environments = Environment.all
    @envestigations = @environments.map { |env| env.envestigate_build_number }
    #mail(:to => 'srawlins@email.arizona.edu', :subject => 'Environment Status')
    mail(:to => 'katt-core@listserv.arizona.edu', :subject => 'Environment Status')
  end
end
