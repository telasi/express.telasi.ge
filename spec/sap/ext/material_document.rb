# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Sap::Ext::MaterialDocument do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_field(:mblnr).of_type(String) }
  it { should have_field(:mjahr).of_type(Integer) }
  it { should have_field(:date).of_type(Date) }
  it { should have_field(:type).of_type(Integer) }
end
