class OCRRunner < Hydra::Derivatives::Runner

  # Adds default language: value to each directive
  def self.transform_directives(options)
    options.each do |directive|
      directive.reverse_merge!(language: 'eng') #FIXME: config default value? set here or in processor?
    end
    options
  end

  def self.output_file_service
    @output_file_service || PersistDirectlyContainedOutputFileService
  end

  # Use the source service configured for this class or default to the global setting
  # FIXME: handle this through initializers setting @source_file_service value?
  def self.source_file_service
    if ESSI.config.dig(:essi, :store_original_files)
      @source_file_service || Hydra::Derivatives::RetrieveSourceFileService
    else 
      @source_file_service || Hydra::Derivatives.source_file_service
    end
  end

  def self.processor_class
    Processors::OCR
  end
end
