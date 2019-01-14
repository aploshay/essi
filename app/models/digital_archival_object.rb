# Generated via
#  `rails generate dog_biscuits:work DigitalArchivalObject`
class DigitalArchivalObject < DogBiscuits::DigitalArchivalObject
  include ::Hyrax::WorkBehavior

  self.indexer = ::DigitalArchivalObjectIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  # include ::Hyrax::BasicMetadata
  include DogBiscuits::DigitalArchivalObjectMetadata
  before_save :combine_dates
end
