# -*- encoding : utf-8 -*-

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
end
