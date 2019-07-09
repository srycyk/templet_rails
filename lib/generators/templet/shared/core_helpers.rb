
module Shared
  module CoreHelpers
    SOURCE_ROOT = File.expand_path('../../templates/core', __FILE__) + '/'

    LIB_ROOT = 'lib/'
    APP_ROOT = 'app/'

    APP_SUBDIR = 'app/'
    HELPERS_SUBDIR = 'helpers/'
    TEMPLET_SUBDIR = 'templet/'
    SPEC_SUBDIR = 'spec/'
    SUPPORT_SUBDIR = 'support/'

    private

    def copy(from, to)
      puts "#{from}\n    => #{to}"
    end

    def copy_helper(file)
      copy_file helper_dir_source(file), helper_dir_target(file)
    end

    #alias copy_file copy
    #alias directory copy

    def rspec?
      Dir.exists? spec_support_dir
    end

    def helper_dir_target(file)
      APP_ROOT + HELPERS_SUBDIR + file
    end
    def spec_support_dir
      SPEC_SUBDIR + SUPPORT_SUBDIR
    end
    def helper_dir_source(file)
      SOURCE_ROOT + HELPERS_SUBDIR + file
    end

    def already_installed_at
      dest_dirs.each do |dir|
        return dir if Dir.exists?(dir) and not Dir.empty?(dir)
      end

      nil
    end

    def dest_dirs
      [ core_default_dir ]
    end

    def core_default_dir
      APP_ROOT + HELPERS_SUBDIR + TEMPLET_SUBDIR
    end
  end
end
