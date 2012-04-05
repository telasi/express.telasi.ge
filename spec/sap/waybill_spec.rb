# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'დოკუმენტის მომზადება' do
  before(:all) do
    @sap_doc = Sap::MaterialDocument.where(:mblnr => '4900074399', :mandt => Express::Sap::MANDT).first
    @waybill = @sap_doc.to_waybill
    @waybill.status = RS::Waybill::STATUS_SAVED
    @waybill.validate
  end
  subject { @waybill }
  it { should be_valid }
  context 'გაგზავნა' do
    before(:all) do
      RS.save_waybill(@waybill, 'su' => Express::SU, 'sp' => Express::SP)
    end
    subject { @waybill }
    its(:error_code) { should == 0 }
  end
end
