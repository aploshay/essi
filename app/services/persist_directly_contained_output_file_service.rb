class PersistDirectlyContainedOutputFileService < Hyrax::PersistDirectlyContainedOutputFileService
    def self.call(content, directives)
      file = io(content, directives)
      file_set = retrieve_file_set(directives)
      remote_file = retrieve_remote_file(file_set, directives)
      remote_file.content = file
      remote_file.mime_type = determine_mime_type(file)
      remote_file.original_name = determine_original_name(file)
      # FIXME: remove debugger line
      # debugger
      remote_file.save
      file_set.save
    end

    # FIXME: better handle getting original_name
    # @param file [Hydra::Derivatives::IoDecorator]
    def self.determine_original_name(file)
      result = super
      result.present? ? result : "derivative"
    end

    # FIXME: better handle getting mime_type
    # @param file [Hydra::Derivatives::IoDecorator]
    def self.determine_mime_type(file)
      result = super
      result.present? ? result : "appliction/octet-stream"
    end
end
