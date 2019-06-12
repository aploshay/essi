# Generated via
#  `rails generate hyrax:work PagedResource`
module Hyrax
  # Generated form for PagedResource
  class PagedResourceForm < Hyrax::Forms::WorkForm
    include ScoobySnacks::WorkFormBehavior
    self.model_class = ::PagedResource
    self.terms += [:resource_type, :source_metadata_identifier, :series]
    self.required_fields -= [:title, :creator, :keyword]
    self.primary_fields = [:title, :creator, :rights_statement, :source_metadata_identifier]
    include ESSI::PagedResourceFormBehavior
  end
end
