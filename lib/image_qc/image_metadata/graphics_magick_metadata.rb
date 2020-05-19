# FIXME: this would require installing graphicsmagick in docker build
module ImageQC
  module ImageMetadata
    class GraphicsMagickMetadata
      attr_accessor :metadata

      def initialize(image)
        cli = MiniMagick.configure { |config| config.cli }
        unless cli == :graphicsmagick
          raise "This image metadata reader requires :graphicsmagick for the CLI but was given :#{cli}"
        end
        # FIXME: rescue error reading 48-bit image?
        @metadata = image.details
        @metadata['colorspace'] = image.colorspace
        @metadata['page_count'] = image.pages.count

        # get ICC from shell extraction as it's not returned by #details?

        # FIXME: this will require installing exiftool in docker build
        require 'open3'
        require 'shellwords'
        @metadata['icc_description'] = \
          Open3.capture2("gm convert #{Shellwords.escape(image.path)} icc:- | exiftool - | grep 'Profile Description' | sed -e 's/^.*: //g'").first.chomp
      end

      def format
        metadata['Format'].match(/^(.*) \(/)[1] rescue nil
      end

      def format_description
        metadata['Format'].match(/\((.*)\)/)[1] rescue nil
      end

      def compression
        return 'None' if metadata['Compression'] == 'No'
        metadata['Compression']
      end

      # FIXME: this returns different results than ImageMagick -- values, not just formatting
      def color_bit_depth
        metadata['Depth'].split.first.to_i
      end

      def icc_description
        metadata['icc_description']
      end

      def image_resolution
        x, y = metadata['Geometry'].split('x').map(&:to_i)
        { x: x, y: y }.with_indifferent_access
      end

      def horizontal_resolution
       image_resolution[:x]
      end 

      def vertical_resolution
       image_resolution[:y]
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
