# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  # Generated form for Image
  class ImageForm < Hyrax::Forms::WorkForm
    include ScoobySnacks::WorkFormBehavior
    self.model_class = ::Image
    self.terms += [:resource_type]
    self.required_fields -= [:keyword]
    self.primary_fields = [:title, :creator, :rights_statement]
    include ESSI::ImageFormBehavior
  end
end
