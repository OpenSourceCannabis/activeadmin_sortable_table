require 'uber/options'

module ActiveAdmin
  #
  module SortableTable
    # Adds `handle_column` method to `TableFor` dsl.
    # @example on index page
    #   index do
    #     handle_column
    #     id_column
    #     # other columns...
    #   end
    #
    # @example table_for
    #   table_for c.collection_memberships do
    #     handle_column
    #     # other columns...
    #   end
    #
    module HandleColumn
      DEFAULT_OPTIONS = {
        show_move_to_top_handle: false,
        sort_url: ->(resource, namespace=ActiveAdmin.application.default_namespace) { url_for([:sort, namespace, resource]) },
        sort_handle: '&#8645;'.html_safe
      }

      # @param [Hash] arguments
      # @option arguments [Symbol, Proc, String] :sort_url
      # @option arguments [Symbol, Proc, String] :sort_handle
      # @option arguments [Symbol, Proc, String] :move_to_top_url
      # @option arguments [Symbol, Proc, String] :move_to_top_handle
      #
      def handle_column(arguments = {})
        defined_options = Uber::Options.new(DEFAULT_OPTIONS.merge(arguments))

        column '', class: 'activeadmin_sortable_table' do |resource|
          options = defined_options.evaluate(self, resource)

          sort_handle(options, resource.send(resource.position_column))
        end
      end

      private

      def sort_handle(options, position)
        content_tag(:span, options[:sort_handle],
                    class: 'handle',
                    'data-sort-url' => options[:sort_url],
                    'data-position' => position,
                    title: 'Drag to reorder'
                   )
      end

    end

    ::ActiveAdmin::Views::TableFor.send(:include, HandleColumn)
  end
end
