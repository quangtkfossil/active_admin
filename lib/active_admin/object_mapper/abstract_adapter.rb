module ActiveAdmin
  module ObjectMapper
    class AbstractAdapter

      class << self

        attr_accessor :adapters

        def register(klass)
          self.adapters ||= []
          self.adapters << klass
        end

        def for(object_mapper, adapter_name, base)
          klass = class_for(object_mapper, adapter_name)
          adapters && adapters.include?(klass) or
            raise NoAdapterFound.new("Adapter #{adapter_name} is not registered")
          klass.new(base)
        end

        def class_for(object_mapper, adapter_name)
          adapter_class = "#{adapter_name}_adapter"
          class_name = "ActiveAdmin::ObjectMapper::#{object_mapper.to_s.classify}::#{adapter_class.classify}"
          Object.const_defined?(class_name) or
            raise NoAdapterFound.new("Class #{class_name} not found")
          class_name.constantize
        end

        def inherited(klass)
          ActiveAdmin::ObjectMapper::AbstractAdapter.register(klass)
        end

      end

      attr_accessor :base

      def initialize(base)
        @base = base
      end

      def method_missing(m, *args, &block)
        if base.respond_to?(m)
          base.send(m, *args, &block)
        else
          super(m, *args, &block)
        end
      end

      def respond_to_missing?(m, include_private)
        base.respond_to?(m, include_private)
      end
    end
  end
end
