
require_relative '../shared/core_helpers'

module Templet
  class InstallGenerator < Rails::Generators::Base
    include Shared::CoreHelpers

    CONTROLLER_SUBDIR = 'controllers/'
    APIS_SUBDIR = 'apis/'

    source_root File.expand_path('./', __FILE__)
    desc

    #DEST_DESC = 'The directory that the core code will be copied beneath'
    #class_option :dest, type: :string, aliases: "-d", default: '', desc: DEST_DESC

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
        directory spec_support_dir_source, spec_support_dir_target

        directory api_support_dir_source, api_support_dir_target
      end
    end

    private

    def create_app_tree
      directory app_dir_source, app_dir_target
    end

    def create_app_rb
      copy_helper 'app.rb'
    end

    def app_dir_source
      SOURCE_ROOT + APP_SUBDIR
    end
    def app_dir_target
      APP_ROOT + HELPERS_SUBDIR + APP_SUBDIR
    end

    def spec_support_dir_source
      SOURCE_ROOT + spec_support_dir + 'viewer/'
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

    def mount_engine
      mount = "mount TempletRails::Engine, at: '/templet'"

      route mount unless IO.read('config/routes.rb') =~ /#{mount}/m
    end
  end
end
