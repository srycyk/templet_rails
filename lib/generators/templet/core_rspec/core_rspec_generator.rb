
require_relative '../shared/core_helpers'

module Templet
  class CoreRspecGenerator < Rails::Generators::Base
    include Shared::CoreHelpers

    PANEL_SUBDIR = 'panel/'

    DESC = "Add specs for the templet core (default: false)"
    class_option 'include-core-specs', type: :boolean, default: false, desc: DESC

    source_root File.expand_path('./', __FILE__)
    desc

    def copy_app_panel_specs
      directory app_panel_dir_source, app_panel_dir_target
    end

    def copy_templet_specs
      if include_core_specs? and Dir.exists? core_default_dir
        directory spec_support_dir_source, spec_support_dir_target

        directory spec_templet_dir_source, spec_templet_dir_target

        puts message_for_file_change
      end
    end

    private

    def app_panel_dir_source
      SOURCE_ROOT + SPEC_SUBDIR + PANEL_SUBDIR
    end
    def app_panel_dir_target
      SPEC_SUBDIR + HELPERS_SUBDIR + APP_SUBDIR + PANEL_SUBDIR
    end

    def spec_templet_dir_source
     SOURCE_ROOT + SPEC_SUBDIR + TEMPLET_SUBDIR
    end

    def spec_templet_dir_target
     SPEC_SUBDIR + HELPERS_SUBDIR + TEMPLET_SUBDIR
    end

    def spec_support_dir_source
      SOURCE_ROOT + spec_support_dir + 'core/'
    end
    def spec_support_dir_target
      spec_support_dir + TEMPLET_SUBDIR
    end

    def include_core_specs?
      options['include-core-specs']
    end

    def message_for_file_change
      %Q(
If you get rspec failures you may need to change values in the file:
    spec/support/templet/model_parent_helpers.rb
Or if you'd rather just get rid of these failing tests run this:
    $ rails generate templet:destroy --rm-core-rspec
)
    end
  end
end

