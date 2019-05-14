module FileSetPresenterAddViewingHints
  delegate :viewing_hint, to: :solr_document
end

Hyrax::FileSetPresenter.class_eval do
  prepend FileSetPresenterAddViewingHints
end

module FileSetEditFormAddViewingHints
  def self.included(base)
    base.class_eval do
      self.terms += [:viewing_hint]
    end
  end
end

Hyrax::Forms::FileSetEditForm.class_eval do
  include FileSetEditFormAddViewingHints
end

module ImageBuilderAddViewingHints
  def apply(canvas)
    canvas['viewingHint'] = canvas_viewing_hint(canvas)
    super
  end

  def canvas_viewing_hint(canvas)
    id = canvas['@id'].split('/').last
    FileSet.search_with_conditions({ id: id }, rows: 1).first['viewing_hint_tesim'].first
  end
end

IIIFManifest::ManifestBuilder::ImageBuilder.class_eval do
  prepend ImageBuilderAddViewingHints
end
