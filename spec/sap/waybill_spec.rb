# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'დოკუმენტის მომზადება' do
  before(:all) do
    @sap_doc = Sap::MaterialDocument.where(:mblnr => '4900074399', :mandt => Express::Sap::MANDT).first
    @waybill = @sap_doc.to_waybill
    ## correcting
    @waybill.status = RS::Waybill::STATUS_SAVED
    @waybill.transport_type_id = RS::TransportType::VEHICLE
    @waybill.car_number = 'WDW842'
    @waybill.driver_tin = '02001000490'
    @waybill.driver_name = 'დიმიტრი ყურაშვილი'
    @waybill.items = [@waybill.items[0]]
    @waybill.validate
  end
  subject { @waybill }
  it { should be_valid }
  context 'გაგზავნა' do
    before(:all) do
      @resp = RS.save_waybill(@waybill, 'su' => Express::SU, 'sp' => Express::SP)
    end
    subject { @resp }
    it { should == 0 }
  end
end
