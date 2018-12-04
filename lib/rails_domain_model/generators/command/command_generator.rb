require 'rails/generators'

module Domain
  module Generators
    class CommandGenerator < Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), './templates'))

      def copy_files
        @context = class_path.first
        @klass = file_name

        command_file = "domain_model/domain/#{@context}/commands/#{@klass}.rb"
        template "command.rb", command_file
        if !File.exists?('domain_model/domain_command.rb')
          template 'domain_command.rb', 'domain_model/domain_command.rb'
        end

        application do
          "config.paths.add 'domain_model', eager_load: true"
        end
      end

    end
  end
end
