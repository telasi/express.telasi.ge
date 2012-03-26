# -*- encoding : utf-8 -*-
module Sap
  class Base < ActiveRecord::Base
    self.abstract_class = true
  end
end
