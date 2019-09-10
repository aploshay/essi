module Processors
  class OCR < Hydra::Derivatives::Processors::Processor
    include Hydra::Derivatives::Processors::ShellBasedProcessor

    def self.encode(path, options, output_file)
      root_file = output_file.gsub('.xml', '')
      hocr_file = "#{root_file}.hocr"
      alto_file = "#{root_file}.tmp.xml"
      execute "tesseract #{path} #{root_file} #{options[:options]} alto"
    end

    def options_for(_format)
      {
        options: string_options
      }
    end

    private

      def string_options
        "-l #{language}" if language.present?
      end

      def language
        directives.fetch(:language, :eng)
      end
  end
end
