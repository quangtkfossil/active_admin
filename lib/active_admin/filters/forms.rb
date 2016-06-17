module ActiveAdmin
  module Filters
    # This form builder defines methods to build filter forms such
    # as the one found in the sidebar of the index page of a standard resource.
    class FormBuilder < ::ActiveAdmin::FormBuilder
      include ::ActiveAdmin::Filters::FormtasticAddons
      self.input_namespaces = [::Object, ::ActiveAdmin::Inputs::Filters, ::ActiveAdmin::Inputs, ::Formtastic::Inputs]

      # TODO: remove input class finders after formtastic 4 (where it will be default)
      self.input_class_finder = ::Formtastic::InputClassFinder

      delegate :filter, to: :form_builder_adapter

      protected

      def form_builder_adapter
        @form_builder_adapter ||=
          ActiveAdmin.object_mapper_for(klass).adapter(:form_builder, self)
      end

    end


    # This module is included into the view
    module ViewHelper

      # Helper method to render a filter form
      def active_admin_filters_form_for(search, filters, options = {})
        defaults = { builder: ActiveAdmin::Filters::FormBuilder,
                     url: collection_path,
                     html: {class: 'filter_form'} }
        required = { html: {method: :get},
                     as: :q }
        options  = defaults.deep_merge(options).deep_merge(required)

        form_for search, options do |f|
          filters.each do |attribute, opts|
            next if opts.key?(:if)     && !call_method_or_proc_on(self, opts[:if])
            next if opts.key?(:unless) &&  call_method_or_proc_on(self, opts[:unless])

            f.filter attribute, opts.except(:if, :unless)
          end

          buttons = content_tag :div, class: "buttons" do
            f.submit(I18n.t('active_admin.filters.buttons.filter')) +
              link_to(I18n.t('active_admin.filters.buttons.clear'), '#', class: 'clear_filters_btn') +
              hidden_field_tags_for(params, except: [:q, :page])
          end

          f.template.concat buttons
        end
      end

    end

  end
end
