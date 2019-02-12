class OCRRunner
  attr_reader :resource, :options
  def initialize(resource, options)
    @resource = resource
    options[:outputs].each { |o| o.reverse_merge!(language: language) }
    @options = options
  end

  def create
    if ESSI.config.dig(:essi, :store_original_files)
      self.from_datastream
    else
      self.from_original_file(filename)
    end
    resource.save
  end

  def from_file(filename, directives)
    creator_factory.create(filename, directives)
  end

  def from_datastream
    Hydra::Derivatives::TempfileService.create(resource.original_file) do |f|
      ocr_output = from_file(f.path, options)
      attach_ocr(ocr_filename(ocr_output))
    end
  end

  def from_original_file(filename)
    ocr_output = from_file(filename, options)
    attach_ocr(ocr_filename(ocr_output))
  end

  private

    def attach_ocr(filename)
      basename = File.basename(filename) if filename
      iodec = Hydra::Derivatives::IoDecorator.new(File.open(filename, 'rb'),
                                                  'text/html', basename)
      # FIXME: this is timing out; why?
      #Hydra::Works::AddFileToFileSet.call(resource, iodec, :extracted_text)
    end

    def ocr_filename(ocr_output)
      ocr_output.first[:url].sub(/^file:/, '')
    end

    def creator_factory
      OCRCreator
    end

    def language
      return try_language(:ocr_language).join("+") if
        try_language(:ocr_language).present?
      return try_language(:language).join("+") if
        try_language(:language).present?
      "eng"
    end

    def try_language(field)
      (parent.try(field) || []).reject do |lang|
        Tesseract.languages[lang.to_sym].nil?
      end
    end

    def parent
      resource.in_works.first
    end
end
