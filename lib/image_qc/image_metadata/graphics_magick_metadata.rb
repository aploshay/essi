module ImageQC
  module ImageMetadata
    class GraphicsMagickMetadata
      attr_accessor :metadata

      def initialize(image)
        cli = MiniMagick.configure { |config| config.cli }
        unless cli == :graphicsmagick
          raise "This image metadata reader requires :graphicsmagick for the CLI but was given :#{cli}"
        end
        @metadata = image.details
        @metadata['colorspace'] = image.colorspace
        @metadata['page_count'] = image.pages.count
      end

      def format
        metadata['Format'].match(/^(.*) \(/)[1] rescue nil
      end

      def format_description
        metadata['Format'].match(/\((.*)\)/)[1] rescue nil
      end

      def compression
        metadata['Compression']
      end

      def image_resolution
        x, y = metadata['Geometry'].split('x').map(&:to_i)
        { x: x, y: y }.with_indifferent_access
      end

      def print_resolution
        dimensions, units = metadata['Resolution'].to_s.split
        dimensions ||= '0x0'
        x, y = dimensions.split('x').map(&:to_f)
        units = begin
          case units
          when 'pixels/inch'
             'PixelsPerInch'
          when 'pixels/centimeter'
             x = (x * 2.54).round
             y = (y * 2.54).round
             'PixelsPerInch'
          when 'pixels'
             'Undefined'
          else
             'Undefined'
          end      
        end
        { units: units, x: x, y: y }.with_indifferent_access
      end

      def page_count
        metadata['page_count']       
      end
    end
  end
end
