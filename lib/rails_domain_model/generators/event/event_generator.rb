require 'rails/generators'

module Domain
  module Generators
    class EventGenerator < Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), './templates'))

      def copy_files
        @context = class_path.first
        @klass = file_name

        event_file = "domain_model/domain/#{@context}/events/#{@klass}.rb"
        template "event.rb", event_file

        if !File.exists?('domain_model/domain_event.rb')
          template 'domain_event.rb', 'domain_model/domain_event.rb'
        end

        application do
          "config.paths.add 'domain_model', eager_load: true"
        end
      end

    end
  end
end
