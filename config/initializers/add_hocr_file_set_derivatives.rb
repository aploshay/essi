Hyrax::FileSetDerivativesService.class_eval do

  def create_derivatives(filename)
    Rails.logger.info 'Create File Set Derivatives Hit'
    case mime_type
      when *file_set.class.pdf_mime_types             then create_pdf_derivatives(filename)
      when *file_set.class.office_document_mime_types then create_office_document_derivatives(filename)
      when *file_set.class.audio_mime_types           then create_audio_derivatives(filename)
      when *file_set.class.video_mime_types           then create_video_derivatives(filename)
      when *file_set.class.image_mime_types
        create_image_derivatives(filename)
        create_hocr_derivatives(filename, uri)
    end
  end

  private

  def create_hocr_derivatives(filename, uri)
    return unless ESSI.config.dig(:essi, :create_hocr_files)
    # FIXME: add language: parameter logic somewhere -- fileset model?
    OCRRunner.create(file_set,
                     { source: :original_file,
                       outputs: [{ label: 'ocr',
                                   format: 'hocr',
                                   container: 'extracted_text',
                                   url: uri }]})
  end
end
