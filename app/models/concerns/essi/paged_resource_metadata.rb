module ESSI
  module PagedResourceMetadata
    extend ActiveSupport::Concern

    included do
      # Add properties that would only be appropriate for use in objects of the Paged Resource Work Type
      property :viewing_hint, predicate: ::RDF::Vocab::IIIF.viewingHint, multiple: false
      property :viewing_direction, predicate: ::RDF::Vocab::IIIF.viewingDirection, multiple: false
      property :ocr_state, predicate: ::RDF::URI.new('http://dlib.indiana.edu/vocabulary/OCRState'), multiple: false do |index|
        index.as :stored_searchable
      end
    end
  end
end
