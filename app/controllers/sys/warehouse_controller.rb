# -*- encoding : utf-8 -*-
module Sys
  class WarehouseController < SysController
    def index
      @title = 'საწყობები'
      @warehouses = Sys::Warehouse.asc(:werks, :lgort).paginate(:page => params[:page], :per_page => 10)
    end

    def new
      @title = 'ახალი საწყობი'
      if request.post?
        @warehouse = Sys::Warehouse.new(params[:sys_warehouse])
        if @warehouse.valid?
          existing = Sys::Warehouse.where(:werks => @warehouse.werks, :lgort => @warehouse.lgort).first
          if existing
            @error = 'ეს საწყობი უკვე სიაშია.'
          elsif @warehouse.sap_warehouse
            @warehouse.name = @warehouse.sap_warehouse.lgobe
            @warehouse.save!
            redirect_to sys_warehouses_url, :notice => 'საწყობი შექმნილია.'
          else
            @error = 'შესაბამისი საწყობი ვერ მოიძებნა SAP-ში.'
          end
        end
      else
        @warehouse = Sys::Warehouse.new
      end
    end

    def sync
      warehouses = Sap::Warehouse.all(:conditions => ['MANDT=?', Express::Sap::MANDT])
      warehouses.each do |w|
        warehouse = Sys::Warehouse.where(:werks => w.werks, :lgort => w.lgort).first
        warehouse = Sys::Warehouse.new(:werks => w.werks, :lgort => w.lgort) unless warehouse
        warehouse.name = w.lgobe
        warehouse.save!
      end
      redirect_to sys_warehouses_url
    end

    def show
      @warehouse = Sys::Warehouse.find(params[:id])
      @sap_warehouse = @warehouse.sap_warehouse
      @sap_addresses = @sap_warehouse.addresses
      @title = @warehouse.name
      @users = Sys::User.asc(:first_name, :last_name)
      @next = next_warehouse(@warehouse)
      @prev = prev_warehouse(@warehouse)
    end

    private

    def next_warehouse(w)
      Sys::Warehouse.all_of(:werks.gte => w.werks, :lgort.gte => w.lgort, :_id.ne => w.id).asc(:werks, :lgort).first
    end

    def prev_warehouse(w)
      Sys::Warehouse.all_of(:werks.lte => w.werks, :lgort.lte => w.lgort, :_id.ne => w.id).desc(:werks, :lgort).first
    end
  end
end
