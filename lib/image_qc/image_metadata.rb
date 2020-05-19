module ImageQC
  module ImageMetadata
    def self.metadata_reader
      cli = MiniMagick.configure { |config| config.cli }
      case cli
      when :graphicsmagick
        GraphicsMagickMetadata
      when :imagemagick
        ImageMagickMetadata
      when :imagemagick7
        raise "ImageMagick7 support not implemented"
      else
        raise "No metadata reader defined for CLI :#{cli}"
      end
    end
  end
end
