require 'rails/generators'

module Domain
  module Generators
    class EventProcessorGenerator < Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), './templates'))

      def copy_files
        @klass = file_name

        processor_file = "app/event_processors/#{@klass}.rb"
        template "processor.rb", processor_file

        if !File.exists?('app/event_processors/application_processor.rb')
          template 'application_processor.rb', 'app/event_processors/application_processor.rb'
        end

        if !File.exists?('config/initializers/sneakers.rb')
          template 'config.rb', 'config/initializers/sneakers.rb'
        end

        application do
          "config.active_job.queue_adapter = :sneakers"
        end
      end

    end
  end
end
