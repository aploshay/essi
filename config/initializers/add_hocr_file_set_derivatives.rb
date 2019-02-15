module FileSetDerivativesServiceExtensions
  def create_derivatives(filename)
    super
    case mime_type
      when *file_set.class.image_mime_types
        create_hocr_derivatives
    end
  end

  private
    def create_hocr_derivatives
      return unless ESSI.config.dig(:essi, :create_hocr_files)
      # FIXME: add language: parameter logic somewhere -- fileset model?
      OCRRunner.create(file_set,
                       { source: :original_file,
                         outputs: [{ label: 'ocr',
                                     format: 'hocr',
                                     container: 'extracted_text',
                                     language: 'eng',
                                     url: uri }]})
    end
end

Hyrax::FileSetDerivativesService.class_eval do
  prepend FileSetDerivativesServiceExtensions
end
