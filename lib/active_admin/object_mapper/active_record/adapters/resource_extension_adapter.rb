require 'active_admin/object_mapper/abstract_adapter'

module ActiveAdmin
  module ObjectMapper
    module ActiveRecord
      class ResourceExtensionAdapter < ActiveAdmin::ObjectMapper::AbstractAdapter

        # Returns a default set of filters for the associations
        def default_association_filters
          if resource_class.respond_to?(:reflect_on_all_associations)
            poly, not_poly = resource_class.reflect_on_all_associations.partition{ |r| r.macro == :belongs_to && r.options[:polymorphic] }

            # remove deeply nested associations
            not_poly.reject!{ |r| r.chain.length > 2 }

            filters = poly.map(&:foreign_type) + not_poly.map(&:name)
            filters.map &:to_sym
          else
            []
          end
        end

      end
    end
  end
end
