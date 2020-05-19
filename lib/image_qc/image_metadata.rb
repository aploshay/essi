module ImageQC
  module ImageMetadata
    def self.metadata_reader
      cli = MiniMagick.configure { |config| config.cli }
      case cli
      when :graphicsmagick
        GraphicsMagickMetadata
      when :imagemagick
        ImageMagickMetadata
      else
        raise "No metadata reader defined for CLI :#{cli}"
      end
    end
  end
end
