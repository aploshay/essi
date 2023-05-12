# modified from stock hyrax to use already-indexed value, if available
module Extensions
  module Hyrax
    module SolrDocument
      module OrderedMembers
        module OrderedMemberIds
          ##
          # @note the purpose of this method is to provide fast access to member
          #   order. currently this is achieved by accessing indexed list proxies
          #   from Solr. however, this strategy may change in the future.
          #
          # @return [Enumerable<String>] ids in the order of their membership,
          #   only includes ids of ordered members.
          def ordered_member_ids
            return [] if id.blank?
            @ordered_member_ids ||= self['ordered_member_ids_ssim'] || query_for_ordered_ids
          end
        end
      end
    end
  end
end
