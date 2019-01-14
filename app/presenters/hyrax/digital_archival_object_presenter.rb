# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work DigitalArchivalObject`
# Updated by
#  `rails generate dog_biscuits:work DigitalArchivalObject`
module Hyrax
  class DigitalArchivalObjectPresenter < Hyrax::WorkShowPresenter
    class << self
      def delegated_properties
        props = DogBiscuits.config.digital_archival_object_properties
        controlled = DigitalArchivalObject.controlled_properties
        props.reject { |p| controlled.include? p }.concat(
          props.select { |p| controlled.include? p }.collect { |c| "#{c}_label".to_sym }
        )
      end
    end

    delegate(*delegated_properties, to: :solr_document)
  end
end
