
require_relative '../shared/core_helpers'

module Templet
  class CoreInstallGenerator < Rails::Generators::Base
    include Shared::CoreHelpers

    CONTROLLER_SUBDIR = 'controllers/'
    APIS_SUBDIR = 'apis/'

    source_root File.expand_path('./', __FILE__)
    desc

    DEST_DESC = 'The directory that the core code will be copied beneath'
    class_option :dest, type: :string, aliases: "-d", default: '', desc: DEST_DESC

    def ensure_uninstalled
      if dir = already_installed_at
        puts "Can't install while there are files present in #{dir}"

        exit
      end
    end

    def create_templet_core
      create_templet_tree

      create_controller_modules

      create_templet_helper_rb
    end

    private

    def create_templet_tree
      directory core_dir_source, core_dir_target
    end

    def create_controller_modules
      directory controller_dir_source, controller_dir_target
    end

    def create_templet_helper_rb
      copy_helper 'templet_helper.rb'
    end

    def core_dir_source
      SOURCE_ROOT + TEMPLET_SUBDIR
    end
    def core_dir_target
      core_dest_subdir + TEMPLET_SUBDIR
    end

    def controller_dir_source
      SOURCE_ROOT + CONTROLLER_SUBDIR
    end
    def controller_dir_target
      APP_ROOT + CONTROLLER_SUBDIR + TEMPLET_SUBDIR
    end

    def dest_dirs
      super + [ LIB_ROOT + TEMPLET_SUBDIR, core_dest_subdir + TEMPLET_SUBDIR ]
    end

    def core_dest_subdir
      if ( dest = options['dest'] ).present?
        if Dir.exists? dest
          dest + (dest.end_with?('/') ? '' : '/')
        else
          raise "Destination directory, #{dest}, must exist"
        end
      else
        APP_ROOT + HELPERS_SUBDIR
      end
    end
  end
end
