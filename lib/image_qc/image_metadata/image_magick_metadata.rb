module ImageQC
  module ImageMetadata
    class ImageMagickMetadata
      attr_accessor :metadata

      # image: ImageMagick::Image
      def initialize(image)
        cli = MiniMagick.configure { |config| config.cli }
        unless cli == :imagemagick
          raise "This image metadata reader requires :imagemagick for the CLI but was given :#{cli}"
        end
        # FIXME: rescue error reading 48-bit image?
        @metadata = image.data
        @metadata['page_count'] = image.pages.count
      end

      def format
        metadata['format']
      end

      def format_description
        metadata['formatDescription']
      end

      def compression
        metadata['compression']
      end

      def color_bit_depth
        metadata['baseDepth']
      end

      def icc_description
        metadata.dig('profile', 'icc:description')
      end

      def image_resolution
        { x: metadata.dig('geometry', 'width').to_i,
          y: metadata.dig('geometry', 'height').to_i
        }.with_indifferent_access
      end

      def horizontal_resolution
       image_resolution[:x]
      end

      def vertical_resolution
       image_resolution[:y]
      end

      def print_resolution
        units = metadata['units'] || 'Undefined'
        x = metadata.dig('resolution', 'x').to_f
        y = metadata.dig('resolution', 'y').to_f
        if units == 'PixelsPerCentimeter'
          x = (x * 2.54).round
          y = (y * 2.54).round
          units = 'PixelsPerInch'
        end
        { units: units, x: x, y: y }.with_indifferent_access
      end

      def print_resolution_units
        print_resolution[:units]
      end

      def horizontal_print_resolution
        print_resolution[:x]
      end

      def vertical_print_resolution
        print_resolution[:y]
      end

      def page_count
        metadata['page_count']     
      end
    end
  end
end
