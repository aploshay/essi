class PersistDirectlyContainedOutputFileService < Hyrax::PersistDirectlyContainedOutputFileService
    def self.call(content, directives)
      file = io(content, directives)
      file_set = retrieve_file_set(directives)
      remote_file = retrieve_remote_file(file_set, directives)
      remote_file.content = file
      remote_file.mime_type = determine_mime_type(file)
      remote_file.original_name = determine_original_name(file)
      # FIXME: remove debugger line, and probably this whole method
      # debugger
      remote_file.save
      file_set.save
    end

    # @param file [Hydra::Derivatives::IoDecorator]
    def self.determine_original_name(file)
#FIXME: check directives
      result = super
      result.present? ? result : "derivative"
    end

    # @param file [Hydra::Derivatives::IoDecorator]
    def self.determine_mime_type(file)
#FIXME: check directives
      result = super
      result.present? ? result : "application/octet-stream"
    end
end
