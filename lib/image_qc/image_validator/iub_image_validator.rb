module ImageQC
  module ImageValidator
    class IUBImageValidator
      attr_reader :metadata_reader
      delegate :format, :compression, :page_count, :image_resolution, :print_resolution, to: :metadata_reader

      def initialize(metadata_reader)
        @metadata_reader = metadata_reader
      end

      def validation_properties
        [:format, :compression, :page_count, :image_resolution, :print_resolution]
      end

      def validation_errors
        validation_properties.map do |property|
          self.send("invalid_#{property}_message") unless self.send("valid_#{property}?")
        end.select(&:present?)
      end

      def valid_format?
        format == 'TIFF'
      end

      def invalid_format_message
        "Format: must be TIFF, but was: #{format}"
      end

      def valid_compression?
        compression == 'None'
      end

      def invalid_compression_message
        "Compression: must be None, but was: #{compression}"
      end

      def valid_page_count?
        page_count == 1
      end

      def invalid_page_count_message
        "Page count: must be a single-page image, but had #{page_count} pages"
      end

      def valid_image_resolution?
        image_resolution.values.select { |v| v >= 1000 }.any?
      end

      def invalid_image_resolution_message
        "Image resolution: must be a minimum of 1000px on the longest edge, but current dimensions are #{image_resolution.values.join('x')}"
      end

      def valid_print_resolution?
        print_resolution['units'] == 'PixelsPerInch' &&
        print_resolution['x'] >= 600 &&
        print_resolution['y'] >= 600
      end

      def invalid_print_resolution_message
        "Print resolution: must be a minimum of 600dpi, but was #{print_resolution['x']}x#{print_resolution['y']} with units of #{print_resolution['units']}"
      end
    end
  end
end
