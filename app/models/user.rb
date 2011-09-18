class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_many :notebooks, :dependent => :destroy
  has_many :notes, :dependent => :destroy

  has_secure_password

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true, :length => { :maximum => 50 }
  validates :email, :presence => true, :format => { :with => email_regex }
  validates :password, :presence => { :on => :create }, :length => { :within => 6..40 }

end
