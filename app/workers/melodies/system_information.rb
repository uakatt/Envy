module Melodies
  class SystemInformation
    @queue = :melodies_queue

    def self.perform(environment_id)
      environment = Environment.find(environment_id)

      #PrivatePub.publish_to(MelodiesNew,
      #                     {:env => environment.code.gsub(/ /, '-'),
      #                      :envestigation => 'accounts-count',
      #                      :message => "#{accounts_count} Accounts (under 'UA', and named 'A%')",
      #                      :screenshot => "build.png"})
    rescue StandardError => e
      #PrivatePub.publish_to(MelodiesNew,
      #                     {:env => environment.code.gsub(/ /, '-'),
      #                      :envestigation => 'build-number',
      #                      :message => "Error. :( I coulndn't find it.",
      #                      :add_class => 'error'})
    end
  end
end

