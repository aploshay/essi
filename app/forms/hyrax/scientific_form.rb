# Generated via
#  `rails generate hyrax:work Scientific`
module Hyrax
  # Generated form for Scientific
  class ScientificForm < Hyrax::Forms::WorkForm
    include ScoobySnacks::WorkFormBehavior
    self.model_class = ::Scientific
    self.terms += [:resource_type]
    self.required_fields -= [:keyword]
    self.primary_fields = [:title, :creator, :rights_statement]
    include ESSI::ScientificFormBehavior
  end
end
