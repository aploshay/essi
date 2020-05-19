module ImageQC
  module ImageValidator
    class IUPUIImageValidator
      attr_reader :metadata_reader
      delegate :format, :compression, :image_resolution, :print_resolution, to: :metadata_reader

      def initialize(metadata_reader)
        @metadata_reader = metadata_reader
      end

      def validation_errors
        []
      end
    end
  end
end
