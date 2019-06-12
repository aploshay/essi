# Generated via
#  `rails generate hyrax:work BibRecord`
module Hyrax
  class BibRecordPresenter < Hyrax::WorkShowPresenter
    include ScoobySnacks::PresenterBehavior
    delegate :series, to: :solr_document
  end
end
