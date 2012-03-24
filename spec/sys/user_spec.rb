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
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
end
