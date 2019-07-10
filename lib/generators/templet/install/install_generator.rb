
require_relative '../shared/core_helpers'

module Templet
  class InstallGenerator < Rails::Generators::Base
    include Shared::CoreHelpers

    CONTROLLER_SUBDIR = 'controllers/'
    APIS_SUBDIR = 'apis/'

    LAYOUTS = '/layouts'

    source_root File.expand_path('./', __FILE__)
    desc

    #DEST_DESC = 'The directory that the app code will be copied beneath'
    #class_option :dest, type: :string, aliases: "-d", default: '', desc: DEST_DESC
    DESC = "Add specs for the layouts (default: false)"
    class_option 'include-layout-specs', type: :boolean, default: false, desc: DESC


    def ensure_uninstalled
      if dir = already_installed_at
        puts "Can't install while there are files present in #{dir}"

        exit
      end
    end

    def create_app
      create_app_tree

      create_app_rb

      mount_engine
    end

    def create_rspec_support
      if rspec?
        %i(shared viewer).each do |subdir|
          directory spec_support_dir_source(subdir), spec_support_dir_target
        end

        directory api_support_dir_source, api_support_dir_target

        create_layout_specs if include_layout_specs?
      end
    end

    private

    def create_app_tree
      directory app_dir_source, app_dir_target
    end

    def create_app_rb
      copy_helper 'app.rb'
    end

    def create_layout_specs
      layouts_source_dir = SOURCE_ROOT + SPEC_SUBDIR + LAYOUTS

      layouts_target_dir = SPEC_SUBDIR + HELPERS_SUBDIR + APP_SUBDIR + LAYOUTS

      directory layouts_source_dir, layouts_target_dir
    end

    def app_dir_source
      SOURCE_ROOT + APP_SUBDIR
    end
    def app_dir_target
      APP_ROOT + HELPERS_SUBDIR + APP_SUBDIR
    end

    def spec_support_dir_source(subdir)
      SOURCE_ROOT + spec_support_dir + "#{subdir}/"
    end
    def spec_support_dir_target
      spec_support_dir + TEMPLET_SUBDIR
    end

    def api_support_dir_source
      SOURCE_ROOT + spec_support_dir + APIS_SUBDIR
    end
    def api_support_dir_target
      spec_support_dir + APIS_SUBDIR
    end

    def dest_dirs
      [ APP_ROOT + HELPERS_SUBDIR + APP_SUBDIR ]
    end

    def include_layout_specs?
      options['include-layout-specs']
    end

    def mount_engine
      mount = "mount TempletRails::Engine, at: '/templet'"

      route mount unless IO.read('config/routes.rb') =~ /#{mount}/m
    end
  end
end
