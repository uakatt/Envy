class Screenshot < ActiveRecord::Base
  belongs_to :envestigation

  has_attached_file :image, :styles => { :medium => "400x400>", :thumb => "120x120>" }
end
