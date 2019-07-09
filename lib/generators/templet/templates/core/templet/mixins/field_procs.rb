
module Templet
  module Mixins
    # Various procs/lambdas for displaying a model's field values
    # For general purpose components that deal with models of any type
    module FieldProcs
      # For retrieving a model's field value (in table rows)
      # 1st arg will be a renderer instance
      def proc_call_method(name)
        Proc.new {|_, model| model.send name }
      end

      # Returns a formatted field value
      def proc_call_method_format(name)
        value_proc = proc_call_method(name)

        Proc.new {|*args| format_field_by_type value_proc.(*args) }
      end

      # To pass parameters to a REST index link
      def proc_index_link_with_params(link_procs, link_text, params)
        link_procs.index_link(link_text, params: params)
      end

      # To pass parameters to an arbitrarily named link
      def proc_action_link_with_params(link_procs, action, link_text, params)
        link_procs.link_by_action(action, params: params,
                                          text: link_text, #title: nil,
                                          on_collection: true)
      end

      # Used in html definition list controls
      # Returns a Hash of field names by Procs
      # The Proc returns a field value of a model passed as 1st arg
      def hash_field_name_by_value_proc(field_names)
        hash_yield_value(field_names, &:to_proc)
      end
      alias show_controls_hash hash_field_name_by_value_proc

      # Used in html table controls

      # Returns a Hash of names by Procs
      # The Proc returns a field value of a model passed as 2nd arg
      def hash_field_name_by_proc_call_method(field_names)
        hash_yield_value(field_names) {|name| proc_call_method name }
      end
      alias index_controls_hash hash_field_name_by_proc_call_method

      # To pass the same parameter to a list of index links
      # Used in html table headings for sorting by field name
      # Returns a Hash with a html link as the key and a Proc
      # The Proc returns a field value of a model passed as 2nd arg
      def hash_proc_link_with_params_by_proc_call_method(field_names,
                                                         param_name,
                                                         link_class='',
                                                         action: nil,
                                                         formatted: true)
        link_procs = rest_link_procs(link_class)

        field_names.inject Hash.new do |hash, field_name|
          params = { param_name => field_name }

          link_text = field_name.to_s.titleize

          link_proc = if action
                        proc_action_link_with_params(link_procs, action,
                                                     link_text, params)
                      else
                        proc_index_link_with_params(link_procs, link_text, params)
                      end

          value_proc = if formatted
                         proc_call_method_format(field_name)
                       else
                         proc_call_method(field_name)
                       end

          hash.merge link_proc => value_proc
        end
      end
      alias index_controls_sortable_hash hash_proc_link_with_params_by_proc_call_method

      private

      # Returns a Hash for use in html tables and lists
      # The key is used in the heading
      # The value is a Proc that is called for each row
      def hash_yield_value(keys)
        keys.inject Hash.new do |acc, key|
          acc.merge key => yield(key.to_sym)
        end
      end

      def format_field_by_type(value)
        case value
        when true, false
          #value ? 'Yes' : 'No'
          value ? icon('ok') : icon('remove')
        when Integer
          pull_right value.to_s + '&nbsp; ' * 3
        when Date
          value.to_s :rfc822
        when Time, DateTime
          value.strftime '%c'
        else
          value
        end
      end

      def pull_right(content=nil)
        "<span class='pull-right'>#{content}</span>".html_safe
      end
      def pull_right_proc(function)
        Proc.new {|*args| pull_right function.(*args) }
      end

      # For displaying REST links as icons (on tables, for example)

      def icon(name)
        "<span class='glyphicon glyphicon-#{name}'></span>".html_safe
      end
      def actions_to_icons
        { show: icon('camera'), edit: icon('pencil'), delete: icon('trash') }
      end
      def member_links_hash_as_icons(size=:md)
        rest_link_procs([:link, size])
            .member_link_hash(action_to_text: actions_to_icons)
      end

      # This is a factory that produces Procs for rendering html links
      # The Proc is passed the current model and parent
      def rest_link_procs(html_class=nil, remote=remote?)
        Templet::Links.rest_link_procs html_class, scope: controllers_path,
                                                   controller: controllers_name,
                                                   remote: remote
      end
    end
  end
end

