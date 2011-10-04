class Note < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user
  belongs_to :notebook

  acts_as_taggable

  validates :content, :presence => true
  validates :user_id, :presence => true
  validates :notebook_id, :presence => true

  default_scope :order => 'notes.updated_at DESC'
end
