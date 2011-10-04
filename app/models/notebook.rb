class Notebook < ActiveRecord::Base
  attr_accessible :title
  belongs_to :user
  has_many :notes
  acts_as_taggable

  validates :title, :presence => true, :length => { :maximum => 80 }
  validates :user_id, :presence => true

  default_scope :order => 'notebooks.updated_at DESC'
end
