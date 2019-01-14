# Generated via
#  `rails generate hyrax:work DigitalArchivalObject`
module Hyrax
  module Actors
    class DigitalArchivalObjectActor < Hyrax::Actors::BaseActor
      include DogBiscuits::Actors::ApplyAuthorities
      include DogBiscuits::Actors::SingularAttributes

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if create was successful
      def create(env)
        apply_authorities(env)
        super
      end

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if update was successful
      def update(env)
        apply_authorities(env)
        super
      end

    end
  end
end
