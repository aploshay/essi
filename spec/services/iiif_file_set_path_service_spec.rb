require 'rails_helper'

RSpec.describe IIIFFileSetPathService do
  let(:content_location) { 's3://localhost:9000/essi-test/ext-store/12/34/ab/cd/1234abcd-original_file.ptif' }
  let(:local_file) { File.open(RSpec.configuration.fixture_path + '/world.png') }
  let(:local_file_set) { FactoryBot.create(:file_set, content: local_file) }
  let(:remote_file_set) { FactoryBot.create(:file_set, content_location: content_location) }
  # define :file_set to use below
  let(:solr_hit) { FileSet.search_with_conditions(id: file_set.id).first }
  let(:solr_document) { SolrDocument.new(solr_hit) }
  # define :presenter_resource to use below
  let(:file_set_presenter) { FileSetPresenter.new(presenter_resource, Ability.new(FactoryBot.build(:user))) }
  # define resource to use below
  let(:service) { described_class.new(resource) }

  describe "#iiif_image_url" do
    context "without a lookup_id value" do
      let(:resource) { Hash.new }
      it "returns nil" do
        expect(service.iiif_image_url).to be_nil
      end
    end
    context "with an original_file_id lookup_id value" do
      let(:file_set) { local_file_set }
      let(:resource) { solr_document }
      it "returns a url" do
        expect(service.lookup_id).not_to match /^s3/
        expect(service.iiif_image_url).to match /^http/
      end
    end
    context "with a content_location lookup_id value" do
      let(:file_set) { remote_file_set }
      let(:resource) { solr_document }
      it "returns a url" do
        expect(service.lookup_id).to match /^s3/
        expect(service.iiif_image_url).to match /^http/
      end
    end
    context "with versioned_file_id lookup" do
      let(:file_set) { local_file_set }
      let(:resource) { solr_document }
      let(:service) { described_class.new(resource, versioned_lookup: true) }
      before do
        allow(resource).to receive(:original_file_id).and_return(nil)
      end
      it "returns a url" do
        expect(service.lookup_id).not_to match /^s3/
        expect(service.iiif_image_url).to match /^http/
        expect(service.instance_variable_get(:@original_file)).not_to be_nil
        expect(service.instance_variable_get(:@versioned_file_id)).not_to be_nil
      end
    end
  end
end
