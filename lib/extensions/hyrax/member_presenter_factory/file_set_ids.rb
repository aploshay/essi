module Extensions
  module Hyrax
    module MemberPresenterFactory
      module FileSetIds
        # These are the file sets that belong to this work, but not necessarily
        # in order.
        # Arbitrarily maxed at 10 thousand; had to specify rows due to solr's default of 10
        def file_set_ids
          @file_set_ids ||= begin
                              ActiveFedora::SolrService.query("{!field f=has_model_ssim}FileSet",
                                                              rows: 10_000,
                                                              fl: ActiveFedora.id_field,
                                                              fq: "{!join from=ordered_targets_ssim to=id}id:\"#{id}/list_source\"")
                                                       .flat_map { |x| x.fetch(ActiveFedora.id_field, []) }
                            end
        end
      end
    end
  end
end
