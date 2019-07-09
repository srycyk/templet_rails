
module Templet
  class DestroyGenerator < Rails::Generators::Base
    ALL_DESC = "Remove all files to do with this framework (default: false)"
    class_option 'all', type: :boolean, default: false, desc: ALL_DESC

    CORE_DESC = "Remove all of the core (framework) files (default: false)"
    class_option 'rm-core', type: :boolean, default: false, desc: CORE_DESC

    APP_DESC = "Remove the application files under app/helpers/app/ and all tests (default: false)"
    class_option 'rm-app', type: :boolean, default: false, desc: APP_DESC

    SPEC_DESC = "Remove just the tests for the template core (default: false)"
    class_option 'rm-core-rspec', type: :boolean, default: false, desc: SPEC_DESC

    DEST_DESC = 'The directory that the core code will be copied into'
    class_option :dest, type: :string, aliases: "-d", default: '', desc: DEST_DESC

    source_root File.expand_path('.', __FILE__)
    desc

    def check
      if rm_all? or rm_core_rspec? or rm_app? or rm_core?
        unless yes? 'Please confirm that you are about to delete a slew of files?'
          exit
        end
      else
        generate 'templet:destroy --help'

        puts 'Note that at least one option needs to be given'

        exit
      end
    end

    def rm_core
      if core_delete?
        rm %w(app/helpers/templet/ lib/templet/)
        rm 'app/helpers/templet_helper.rb'

        if ( dest = options['dest'] ).present?
          rm dest
        end
      end
    end

    def rm_controller
      if core_delete?
        rm %w(app/controllers/templet/)
      end
    end

    def rm_helpers_rb
      if core_delete?
      end
    end

    def rm_app_trees
      if app_delete?
        rm 'app/helpers/app.rb'

        rm 'app/helpers/app/'

        rm %w(spec/helpers/app/ spec/support/templet/)

        rm %w(spec/apis/ spec/support/apis/)

        puts "Note that any generated controllers won't have been removed"
        puts "  You'll have to manually delete these yourself"
        puts "  There may also be entries in config/routes.rb"
      end
    end

    def rm_core_rspec
      if rm_all? or rm_core? or rm_core_rspec?
        rm %w(spec/helpers/templet/)

        rm %w(spec/support/templet/rest_link_procs_assignments.rb
              spec/support/templet/rest_link_procs_helpers.rb
              spec/support/templet/model_parent_helpers.rb)
      end
    end

    private

    def rm(*paths)
      paths.flatten.compact.each do |path|
        #puts "  #{exists?(path) ? '*' : '?'} #{path}"

        remove_file path if exists?(path)
      end
    end

    def exists?(path)
      if not path or path.empty?
        false
      elsif path.include?('.') or path =~ /[A-Z]/ or not path.end_with?('/')
        File.exists? path
      else
        Dir.exists? path
      end
    end

    def core_delete?
      rm_all? or (rm_core? and not rm_core_rspec?)
    end

    def app_delete?
      rm_all? or (rm_app? and not rm_core_rspec?)
    end

    def rm_core_rspec?
      options['rm-core-rspec']
    end

    def rm_app?
      options['rm-app']
    end

    def rm_core?
      options['rm-core']
    end

    def rm_all?
      options['all']
    end
  end
end

