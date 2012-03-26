# -*- encoding : utf-8 -*-
module SAP
  class Base < ActiveRecord::Base
    self.abstract_class = true
  end
end
