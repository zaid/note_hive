require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {
      :name => 'Example User',
      :email => 'user@example.ca',
      :password => 'foobar',
      :password_confirmation => 'foobar'
    }
  end

  it "should create a new instance given valid attribtues" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ''))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ''))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = 'a' * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_user@foo.bar.org first.last@place.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com THE_user_at_foo.bar.org first.last@place.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject duplicate email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do
    
    it "should require a password" do
      passwordless_user = User.new(@attr.merge(:password => '', :password_confirmation => ''))
      passwordless_user.should_not be_valid
    end

    it "should require a matching password confirmation" do
      mismatching_password_user =  User.new(@attr.merge(:password_confirmation => 'invalid'))
      mismatching_password_user.should_not be_valid 
    end

    it "should reject short passwords" do
      short = 'a' * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      short_password_user = User.new(hash)
      short_password_user.should_not be_valid
    end

    it "should reject long passwords" do
      long = 'a' * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      long_password_user = User.new(hash)
      long_password_user.should_not be_valid
    end
  end

  describe "notebook associations" do
    
    before(:each) do
      @user = Factory(:user)
      @nb1 = Factory(:notebook, :user => @user)
    end

    it "should have a notebook attribute" do
      @user.should respond_to(:notebooks)
    end

    it "should destroy associated notebooks" do
      @user.destroy
      Notebook.find_by_id(@nb1.id).should be_nil
    end
  end

  describe "note associations" do
    
    before(:each) do
      @user = Factory(:user)
      @notebook = Factory(:notebook, :user => @user)
      @note = Factory(:note, :user => @user, :notebook => @notebook)
    end

    it "should have a notebook attribute" do
      @user.should respond_to(:notes)
    end
  end
end
