# ActiveRecord-specific plugins should be required here

ActiveAdmin::DatabaseHitDuringLoad.database_error_classes << ActiveRecord::StatementInvalid

require 'active_admin/object_mapper/active_record/comments'

require 'active_admin/object_mapper/active_record/adapters/form_builder_adapter'
require 'active_admin/object_mapper/active_record/adapters/formtastic_addons_adapter'
require 'active_admin/object_mapper/active_record/adapters/resource_extension_adapter'

module ActiveAdmin
  module ObjectMapper
    module ActiveRecord

      def self.adapter(name, base)
        AbstractAdapter.for(:active_record, name, base)
      end

    end
  end
end
