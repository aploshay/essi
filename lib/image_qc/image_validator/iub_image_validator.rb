module ImageQC
  module ImageValidator
    class IUBImageValidator < CustomizableImageValidator
      DEFAULT_VALIDATIONS = { format: 'TIFF',
                              compression: ['No', 'None', ''],
                              page_count: [1],
                              horizontal_resolution: [400, 600, 2400, 3000],
                              vertical_resolution: [400, 600, 2400, 3000],
                              image_resolution: :validate_1000px_minimum,
                              print_resolution: :validate_600dpi_minimum,
                              color_bit_depth: { 1 => {},
                                                 8 => {},
                                                 24 => { icc_description: 'Adobe RGB (1998)' }
                                               }
                            }

      def validate_600dpi_minimum(_property, print_resolution)
        unless print_resolution['units'] == 'PixelsPerInch' &&
               print_resolution['x'] >= 600 &&
               print_resolution['y'] >= 600
          "Print resolution must be a minimum of 600dpi, but was #{print_resolution['x']}x#{print_resolution['y']} with units of #{print_resolution['units']}"
        end
      end

      def validate_1000px_minimum(_property, image_resolution)
        unless image_resolution['x'] >= 1000 ||
               image_resolution['y'] >= 1000
          "Image resolution must be a minimum of 1000px along the longer edge, but was #{image_resolution['x']}x#{image_resolution['y']}"
          end
      end
    end
  end
end
