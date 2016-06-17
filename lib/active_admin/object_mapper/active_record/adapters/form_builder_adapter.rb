require 'active_admin/object_mapper/abstract_adapter'

module ActiveAdmin
  module ObjectMapper
    module ActiveRecord
      class FormBuilderAdapter < ActiveAdmin::ObjectMapper::AbstractAdapter
        def filter(method, options = {})
          if method.present? && options[:as] ||= default_input_type(method)
            template.concat input(method, options)
          end
        end

        private

        # Returns the default filter type for a given attribute. If you want
        # to use a custom search method, you have to specify the type yourself.
        def default_input_type(method, options = {})
          if method =~ /_(eq|equals|cont|contains|start|starts_with|end|ends_with)\z/
            :string
          elsif klass._ransackers.key?(method.to_s)
            klass._ransackers[method.to_s].type
          elsif reflection_for(method) || polymorphic_foreign_type?(method)
            :select
          elsif column = column_for(method)
            case column.type
            when :date, :datetime
              :date_range
            when :string, :text
              :string
            when :integer, :float, :decimal
              :numeric
            when :boolean
              :boolean
            end
          end
        end
      end
    end
  end
end
