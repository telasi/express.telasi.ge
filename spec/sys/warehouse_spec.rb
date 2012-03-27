# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Sys::Warehouse do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_field :name }
  it { should have_field :lgort }
  it { should have_field :werks }
  it { should validate_presence_of :lgort }
  it { should validate_presence_of :werks }
end

describe 'SAP-ის საწყობის მიღება' do
  before(:all) do
    @warehouse = FactoryGirl.create('sys/warehouse', :werks => '1000', :lgort => 'M007')
  end
  subject { @warehouse.sap_warehouse }
  it { should_not be_nil }
  its(:lgobe) { should == 'ფანცულაია ვარლამ' }
end
