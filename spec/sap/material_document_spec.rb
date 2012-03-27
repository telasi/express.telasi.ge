# -*- encoding : utf-8 -*-
require 'rs'

describe 'მასალის დოკუმენტის ამოღება' do
  before(:all) do
    @doc = Sap::MaterialDocument.find(MANDT, '5000000058', 2011)
  end
  subject { @doc }
  it { should_not be_nil }
  its(:mandt) { should == MANDT }
  its(:mblnr) { should == '5000000058' }
  its(:items) { should_not be_empty }
  its(:bldat_date) { should be_instance_of Date }
  its(:budat_date) { should be_instance_of Date }
  context 'convert into RS waybill' do
    before(:all) do
      @waybill = @doc.to_waybill
    end
    subject { @waybill }
    it { should_not be_nil }
    it { should be_instance_of RS::Waybill }
    its(:type) { should == RS::WaybillType::INNER }
    its(:seller_id) { should == Express::TELASI_PAYER_ID }
    its(:seller_name) { should == Express::TELASI_NAME }
    its(:seller_tin)  { should == Express::TELASI_TIN }
    its(:buyer_name) { should == Express::TELASI_NAME }
    its(:buyer_tin)  { should == Express::TELASI_TIN }
    its(:check_buyer_tin) { should == true }
    its(:start_address) { should == 'ცენტრალური ოფისი ვანის ქ. № 3' }
    its(:end_address) { should == 'ცენტრალური ოფისი ვანის ქ. № 3' }
    context "items" do
      subject { @waybill.items }
      it { should_not be_nil }
      it { should_not be_empty }
      its(:size) { should == @waybill.items.size }
      context "first item" do
        subject { @waybill.items.first }
        its(:prod_name) { should == 'მაერთებელი განშტოების P2X-95' }
        its(:quantity) { should == 50 }
        its(:unit_id) { should == RS::WaybillUnit::OTHERS }
        its(:bar_code) { should == '100002658' }
        its(:unit_name) { should == 'ST' }
        its(:price) { should == 0 }
      end
    end
  end
end
