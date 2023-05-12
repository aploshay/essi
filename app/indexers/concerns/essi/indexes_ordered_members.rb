module ESSI
  module IndexesOrderedMembers
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc['ordered_member_ids_ssim'] = Hyrax::SolrDocument::OrderedMembers.decorate(SolrDocument.new(solr_doc)).send(:query_for_ordered_ids)
      end
    end
  end
end
