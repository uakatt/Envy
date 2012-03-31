module Melodies
  class SystemInformation
    @queue = :melodies_queue

    def self.perform(environment_id)
      environment = Environment.find(environment_id)
      statistics = Melodie.parse(environment.code)
      if (statistics.is_a? Melodie::Statistics)
        statistics = {environment.code => statistics}
      end
      statistics.each do |code, stats|
        mel_snapshot = MelodieSnapshot.new(
          :system_information => stats.system_information,
          :system_details     => stats.system_details,
          :taken_at           => stats.taken_at,
          :host               => stats.system_information[:host]
        )
        mel_snapshot.environment = environment
        mel_snapshot.save
      end

    rescue OpenURI::HTTPError => e
      mel_snapshot = MelodieSnapshot.create(
        :taken_at           => Time.now,
        :environment        => environment,
        :snapshot_errors    => e
      )
    end
  end
end

