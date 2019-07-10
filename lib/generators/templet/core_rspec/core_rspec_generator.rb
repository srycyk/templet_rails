
require_relative '../shared/core_helpers'

module Templet
  class CoreRspecGenerator < Rails::Generators::Base
    include Shared::CoreHelpers

    source_root File.expand_path('./', __FILE__)
    desc

    def copy_templet_specs
      if Dir.exists? core_default_dir
        %i(shared core).each do |subdir|
          directory spec_support_dir_source(subdir), spec_support_dir_target
        end

        directory spec_templet_dir_source, spec_templet_dir_target

        puts message_for_file_change
      end
    end

    private

    def spec_templet_dir_source
     SOURCE_ROOT + SPEC_SUBDIR + TEMPLET_SUBDIR
    end

    def spec_templet_dir_target
     SPEC_SUBDIR + HELPERS_SUBDIR + TEMPLET_SUBDIR
    end

    def spec_support_dir_source(subdir)
      SOURCE_ROOT + spec_support_dir + "#{subdir}/"
    end
    def spec_support_dir_target
      spec_support_dir + TEMPLET_SUBDIR
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

