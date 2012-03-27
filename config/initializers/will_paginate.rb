require 'mongoid'
require 'will_paginate/collection'

module WillPaginate
  module Mongoid
    module CriteriaMethods
      def paginate(options = {})
        extend CollectionMethods
        @current_page = (options[:page] || 1).to_i
        @per_page = (options[:per_page] || WillPaginate.per_page).to_i
        @page_multiplier = current_page - 1
        limit(per_page).skip(@page_multiplier * per_page)
      end
    end

    module CollectionMethods
      attr_reader :current_page, :per_page
      def total_entries
        count
      end

      def total_pages
        (total_entries / @per_page.to_f).ceil
      end

      def offset
        @page_multiplier * per_page
      end
    end

    ::Mongoid::Criteria.send(:include, CriteriaMethods)
  end
end

module WillPaginate
  module ActionView
    def will_paginate(collection = nil, options = {})
      options[:renderer] ||= BootstrapLinkRenderer
      super.try :html_safe
    end

    class BootstrapLinkRenderer < LinkRenderer
      protected
      def html_container(html)
        tag :div, tag(:ul, html), container_attributes
      end

      def page_number(page)
        tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
      end

      def previous_or_next_page(page, text, classname)
        tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
      end
    end
  end
end