module ESSI
  module Actors
    class QualityControlUploadedFilesActor < Hyrax::Actors::AbstractActor
      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if create was successful
      def create(env)
        uploaded_file_ids = filter_file_ids(env.attributes.dig(:uploaded_files))
        files = uploaded_files(uploaded_file_ids)
        validate_files(files, env) && next_actor.create(env)
      end

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if update was successful
      def update(env)
        uploaded_file_ids = filter_file_ids(env.attributes.dig(:uploaded_files))
        files = uploaded_files(uploaded_file_ids)
        validate_files(files, env) && next_actor.update(env)
      end

      private
        def validator_class
          ESSI.config.dig(:essi, :image_qc, :validator).constantize rescue nil
        end

        # FIXME: make image QC configurable
        # FIXME: only validate _image_ files
        # FIXME: exempt branding images from QC?
        def validate_files(files, env)
          return true unless validator_class.present?
          error_string = ""
          files.each do |uf|
            file_path = uf.file.to_s
            filename = file_path.split('/').last
            image = MiniMagick::Image.new(file_path)
            metadata_reader = ImageQC::ImageMetadata.metadata_reader.new(image)
            metadata_validator = ImageQC::ImageValidator::IUBImageValidator.new(metadata_reader)
            errors = metadata_validator.validation_errors
            if errors.any?
              error_string = "File validation errors for #{filename}: #{errors.join('; ')}"
              env.curation_concern.errors.add(:base, error_string)
              break
            end
          end
          error_string.blank?
        end

        def filter_file_ids(input)
          Array.wrap(input).select(&:present?)
        end

        # Fetch uploaded_files from the database
        def uploaded_files(uploaded_file_ids)
          return [] if uploaded_file_ids.empty?
          ::Hyrax::UploadedFile.find(uploaded_file_ids)
        end
    end
  end
end
