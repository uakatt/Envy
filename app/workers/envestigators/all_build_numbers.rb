module Envestigators
  class AllBuildNumbers
    @queue = :webdriver_queue

    def self.perform()
      NotificationMailer.environments_notification.deliver
    end
  end
end

