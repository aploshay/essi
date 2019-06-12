# Provide a dummy GenericWork model to satisfy Hyrax FactoryBot factories.
# It isn't available as a work type because it isn't complete and
# isn't initialized on startup.
class GenericWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  validates :title, presence: { message: 'Your work must have a title.' }

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  # include ::Hyrax::BasicMetadata
  include ScoobySnacks::WorkModelBehavior
end
