# -*- encoding : utf-8 -*-
module Sys
  class WarehouseController < SysController
    def index
      @warehouses = Sys::Warehouse.all.asc(:name)
    end
  end
end
