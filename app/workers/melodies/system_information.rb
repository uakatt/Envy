module Melodies
  class SystemInformation
    @queue = :melodies_queue

    def self.perform(environment_id)
      environment = Environment.find(environment_id)

      stats = Melodie.parse(environment.code)
      mel_snapshot = MelodieSnapshot.new(
        :system_information => stats.system_information,
        :system_details     => stats.system_details,
        :taken_at           => stats.taken_at,
        :host               => stats.system_information[:host]
      )
      mel_snapshot.environment = environment
      mel_snapshot.save

      #PrivatePub.publish_to(MelodiesNew,
      #                     {:env => environment.code.gsub(/ /, '-'),
      #                      :envestigation => 'accounts-count',
      #                      :message => "#{accounts_count} Accounts (under 'UA', and named 'A%')",
      #                      :screenshot => "build.png"})
    #rescue StandardError => e
    end
  end
end

