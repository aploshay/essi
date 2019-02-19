class OCRRunner < Hydra::Derivatives::Runner

  # Adds default language: value to each directive
  def self.transform_directives(options)
    options.each do |directive|
      directive.reverse_merge!(language: 'eng') #FIXME: config default value? set here or in processor?
    end
    options
  end

  # Facilitate storing the output as :extracted_text
  def self.output_file_service
    @output_file_service || PersistDirectlyContainedOutputFileService
  end

  def self.processor_class
    Processors::OCR
  end
end
