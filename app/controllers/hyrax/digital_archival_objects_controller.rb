# Generated via
#  `rails generate hyrax:work DigitalArchivalObject`
module Hyrax
  # Generated controller for DigitalArchivalObject
  class DigitalArchivalObjectsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::DigitalArchivalObject

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::DigitalArchivalObjectPresenter
  end
end
