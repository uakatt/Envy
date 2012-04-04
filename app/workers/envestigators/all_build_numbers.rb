module Envestigators
  class AllBuildNumbers
    @queue = :webdriver_queue

    def self.perform()
      environments = Environment.all
      envestigations = environments.map { |env| env.envestigate_build_number }
    end
  end
end

