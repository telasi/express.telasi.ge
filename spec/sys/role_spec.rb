# -*- encoding : utf-8 -*-

require 'spec_helper'

describe Sys::Role do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_field(:name).of_type(String) }
  it { should have_field(:description).of_type(String) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_and_belong_to_many(:users) }
end