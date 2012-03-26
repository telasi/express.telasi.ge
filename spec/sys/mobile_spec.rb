# -*- encoding : utf-8 -*-

require 'spec_helper'

def correct_mobile(mob)
  context mob do
    subject { Sys.correct_mobile? mob }
    it('უნდა იყოს სწორი') { should == true }
  end
end

def incorrect_mobile(mob)
  context mob do
    subject { Sys.correct_mobile? mob }
    it('არაა სწორი') { should == false }
  end
end

def check_mobile_format(mob, formatted)
  context "#{mob} as #{formatted}" do
    subject { formatted }
    it { should == Sys.format_mobile(mob) }
  end
end

describe 'მობილურის სისწორის შემოწმება' do
  correct_mobile '595335514'
  correct_mobile '599422451'
  correct_mobile '(595)335-514'
  correct_mobile '(595)33-55-14'
  correct_mobile '+(595)33-55-14'

  incorrect_mobile '59533551'
  incorrect_mobile '123'
  incorrect_mobile '5953355145'
  incorrect_mobile nil
end

describe 'მობილურის ფორმატის შემოწმება' do
  check_mobile_format '595335514', '(595)335-514'
  check_mobile_format '(595)33-55-14', '(595)335-514'
end