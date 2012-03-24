# -*- encoding : utf-8 -*-

require 'spec_helper'

describe Sys::User do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_field(:email).of_type(String) }
  it { should have_field(:admin).of_type(Boolean) }
  it { should have_field(:salt).of_type(String) }
  it { should have_field(:hashed_password).of_type(String) }
  it { should have_field(:first_name).of_type(String) }
  it { should have_field(:last_name).of_type(String) }
  it { should have_field(:mobile).of_type(String) }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :mobile }
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
end

describe 'მომხმარებლის შექმნა' do
  before(:all) do
    @admin = FactoryGirl.create('sys/user', :mobile => '(595)335514', :email => 'dimitri@c12.ge')
  end
  subject { @admin }
  its(:admin) { should == true }
  its(:mobile) { should == '595335514' }
  its(:salt) { should_not be_nil }
  its(:salt) { should_not be_empty }
  its(:hashed_password) { should_not be_nil }
  its(:hashed_password) { should_not be_empty }
  context 'მეორე მომხმარებლის დამატება' do
    before(:all) do
      @user = FactoryGirl.create('sys/user', :mobile => '(595)335588', :email => 'dimakura@gmail.com')
    end
  end
end
