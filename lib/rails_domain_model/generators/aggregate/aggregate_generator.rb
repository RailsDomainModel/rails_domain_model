require 'rails/generators'

module Domain
  module Generators
    class AggregateGenerator < Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), './templates'))

      def copy_files
        @context = class_path.first
        @klass = file_name

        aggregate_file = "domain_model/domain/#{@context}/#{@klass}.rb"

        template "aggregate.rb", aggregate_file
        if !File.exists?('domain_model/domain_aggregate.rb')
          template 'domain_aggregate.rb', 'domain_model/domain_aggregate.rb'
        end

        application do
          "config.paths.add 'domain_model', eager_load: true"
        end
      end
    end
  end
end
