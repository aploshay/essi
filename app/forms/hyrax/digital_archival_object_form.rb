# Generated via
#  `rails generate dog_biscuits:work DigitalArchivalObject`
module Hyrax
  class DigitalArchivalObjectForm < Hyrax::Forms::WorkForm
    self.model_class = DigitalArchivalObject

    self.terms -= DogBiscuits.config.base_properties
    self.terms += DogBiscuits.config.digital_archival_object_properties

    # Add any local properties here
    self.terms += []

    self.required_fields = DogBiscuits.config.digital_archival_object_properties_required

    # The service that determines the cardinality of each field
    self.field_metadata_service = ::LocalFormMetadataService
  end
end
