module Extensions
  module Hyrax
    module MemberPresenterFactory
      module FileSetIds
        # These are the file sets that belong to this work, but not necessarily
        # in order.
        # Arbitrarily maxed at 10 thousand; had to specify rows due to solr's default of 10
        def file_set_ids
          @file_set_ids ||= @work['file_set_ids_ssim']
        end
      end
    end
  end
end
