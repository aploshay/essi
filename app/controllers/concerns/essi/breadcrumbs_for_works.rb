module ESSI
  module BreadcrumbsForWorks
    extend ActiveSupport::Concern
    include Hyrax::Breadcrumbs

    class_methods do
      # We don't want the breadcrumb action to occur until after the concern has
      # been loaded and authorized
      def curation_concern_type=(curation_concern_type)
        super
        before_action :build_breadcrumbs, only: [:edit, :show, :new, :structure, :file_manager]
      end
    end

    private

      def add_breadcrumb_for_action
        super
        case action_name
        when 'structure'.freeze
          add_breadcrumb curation_concern.to_s, main_app.polymorphic_path(curation_concern)
          add_breadcrumb t(:'hyrax.works.structure.breadcrumb'), request.path
        when 'file_manager'.freeze
          add_breadcrumb curation_concern.to_s, main_app.polymorphic_path(curation_concern)
          add_breadcrumb t(:'hyrax.works.file_manager.breadcrumb'), request.path
        end
      end
  end
end
