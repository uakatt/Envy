class MelodieSnapshot < ActiveRecord::Base
  belongs_to :environment

  serialize :system_information
  serialize :system_details
end
