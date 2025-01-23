class IIIFFileSetPathService
  attr_reader :file_set, :lookup_id

  # @param [ActiveFedora::SolrHit, FileSet, SolrDocument, FileSetPresenter] file_set
  def initialize(file_set, versioned_lookup: false)
    file_set = SolrDocument.new(file_set) if file_set.is_a? ActiveFedora::SolrHit
    @file_set = file_set
    @lookup_id = (versioned_lookup ? versioned_lookup_id : basic_lookup_id)
  end

  # @return [String] a URL that resolves to an image provided by a IIIF image server
  def iiif_image_url(base_url: nil, size: nil)
    return unless lookup_id
    Hyrax.config.iiif_image_url_builder.call(lookup_id, base_url, size || Hyrax.config.iiif_image_size_default)
  end

  # @return [String] a URL that resolves to an info.json file provided by a IIIF image server
  def iiif_info_url(base_url)
    return unless lookup_id
    Hyrax.config.iiif_info_url_builder.call(lookup_id, base_url)
  end

  private
    # imported logic from IIIFThumbnailPathService, etc
    def basic_lookup_id
      file_set.content_location || file_set.original_file_id
    end

    # imported from Hyrax::DisplaysImage
    def versioned_lookup_id
      return file_set.content_location if file_set.content_location&.start_with?('s3://')
      result = file_set.original_file_id
      if result.blank?
        Rails.logger.warn "original_file_id for #{id} not found, falling back to Fedora."
        # result = Hyrax::VersioningService.versioned_file_id(original_file)
        result = versioned_file_id(original_file)
      end
      result
    end
  
    # @return Hydra::PCDM::File
    def original_file
      @original_file ||= 
        case file_set
        when FileSet
          file_set.original_file
        else
          FileSet.find(id).original_file
        end
    end

    # @todo remove after upgrade to Hyrax 3.x
    # cherry-picked from Hyrax 3.x VersioningService
    # @param [ActiveFedora::File | Hyrax::FileMetadata] content
    def versioned_file_id(file)
      versions = file.versions.all
      if versions.present?
        ActiveFedora::File.uri_to_id versions.last.uri
      else
        file.id
      end
    end
end
