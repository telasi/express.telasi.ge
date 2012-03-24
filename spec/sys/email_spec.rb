# -*- encoding : utf-8 -*-

require 'spec_helper'

def correct_email(email)
  context email do
    subject { Sys.correct_email? email }
    it('სწორია') { should == true }
  end
end

def incorrect_email(email)
  context email do
    subject { Sys.correct_email? email }
    it('არასწორია') { should == false }
  end
end

describe 'ელექტრონული ფოსტის ფორმატი' do
  correct_email 'dimitri@c12.ge'
  correct_email 'dimakura@gmail.com'
  correct_email 'dimitri.kurashvili@telasi.ge'
  incorrect_email 'dimitri@'
  incorrect_email 'dimitri'
  incorrect_email '@c12.ge'
end
