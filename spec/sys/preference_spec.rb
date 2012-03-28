# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'მომხმარებლის მნიშვნელობი' do
  before(:all) do
    @user = FactoryGirl.create('sys/user')
  end
  subject { Preference.get(@user, 'name') }
  it { should be_nil }
  context 'განსაზღვრული' do
    before(:all) do
      @resp = Preference.set(@user, 'name', 'Dimitri Kurashvili')
    end
    subject { Preference.get(@user, 'name') }
    it { should_not be_nil }
    it { should == 'Dimitri Kurashvili' }
    specify { @resp.should == true }
  end
end
