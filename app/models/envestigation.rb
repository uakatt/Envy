class Envestigation < ActiveRecord::Base
  belongs_to :environment
  has_many :screenshots

  serialize :exception
end
