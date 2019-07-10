
module Templet
  module Viewer
    # Provides controls for scaffolding defaults for index, show, and forms
    module MetaModelDefaults
      private

      # Html default display controls - for overriding

      def index_controls(*args)
        procs_by_name = args.pop if Hash === args.last

        link_procs = args.pop || default_rest_link_procs

        procs_by_name ||= hash_field_name_by_proc_call_method_default

        forward_link(link_procs, to: procs_by_name)

        procs_by_name.merge(link_procs.member_link_hash)
      end

      def default_rest_link_procs
        rest_link_procs(%i(default sm), remote?)
      end

      def hash_field_name_by_proc_call_method_default
        hash_field_name_by_proc_call_method(meta_model.listing_names)
      end

      def forward_link(link_procs=rest_link_procs(:link), to: nil)
        if forward
          text = forward.to_s.capitalize

          link = link_procs.index_link(text, name: forward)

          (block_given? ? yield(link) : link).tap do |link_proc|
            to[:"_#{forward}"] = link_proc if to
          end
        end
      end

      def show_controls(field_names=meta_model.names)
        hash_field_name_by_value_proc field_names
      end

      def form_inputs(field, group=nil)
        meta_model.input_names.map do |field_name|
          input_method_name = meta_model.input(field_name)

          field.send(input_method_name, field_name)
        end
      end
    end
  end
end

