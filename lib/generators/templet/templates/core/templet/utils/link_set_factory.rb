
module Templet
  module Utils
    # Creates lists of HTML links for REST actions
    class LinkSetFactory < Struct.new(:renderer, :action, :klass, :options)
      def call(**extra_options)
        create extra_options
      end

      private

      def create(**extra_options)
        get_class.new(*link_set_args(extra_options)).(action)
      end

      def link_set_args(**extra_options)
        renderer.link_set_args_proc.(renderer, get_options(extra_options))
      end

      def get_class
        case klass
        when Class
          klass
        when String
          klass.constantize
        when :navigation, :nav
          Templet::Links::BsLinkSetNavigation
        else
          Templet::Links::BsLinkSetCollection
        end
      end

      def get_options(**extra_options)
        { html_class: %i(default md) }
          .merge(options || {})
          .merge(extra_options)
      end

=begin
      def class_name_defined?(class_name)
        class_name.constantize rescue false
      end
=end
    end
  end
end
