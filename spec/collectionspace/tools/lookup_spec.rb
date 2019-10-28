require 'rails_helper'

RSpec.describe Lookup do
  describe "can find converter class names" do
    it "returns the authority class" do
      expect(
        Lookup.authority_class('Person')
      ).to eq CollectionSpace::Converter::Core::CorePerson
    end

    it "returns the converter class" do
      expect(
        Lookup.converter_class
      ).to eq CollectionSpace::Converter::Core
    end

    it "returns the converter domain" do
      expect(
        Lookup.converter_domain
      ).to eq 'core.collectionspace.org'
    end

    it "returns the converter module" do
      expect(
        Lookup.converter_module
      ).to eq 'Core'
    end

    it "returns the default authority class" do
      expect(
        Lookup.default_authority_class('Person')
      ).to eq CollectionSpace::Converter::Default::Person
    end

    it "returns the default converter class" do
      expect(
        Lookup.default_converter_class
      ).to eq CollectionSpace::Converter::Default
    end

    it "returns the default relationship class" do
      expect(
        Lookup.default_relationship_class
      ).to eq CollectionSpace::Converter::Default::Relationship
    end

    it "returns the default vocabulary class" do
      expect(
        Lookup.default_vocabulary_class
      ).to eq CollectionSpace::Converter::Default::Vocabulary
    end

    it "returns the import service class" do
      expect(
        Lookup.import_service("Procedures")
      ).to eq ImportService::Procedures
    end

    it "returns the module class" do
      expect(
        Lookup.module_class("Person")
      ).to eq CollectionSpace::Converter::Core::CorePerson
    end

    it "returns the parts classes" do
      ["Authority", "Procedure", "Relationship"].each do |type|
        expect(
          Lookup.parts_for(type)
        ).to eq "Fingerprint::#{type}".constantize
      end
    end

    it "returns the procedure class" do
      expect(
        Lookup.procedure_class('CollectionObject')
      ).to eq CollectionSpace::Converter::Core::CoreCollectionObject
    end

    it "returns the profile config cataloging" do
      expect(
        Lookup.profile_config("cataloging")
      ).to have_key("CollectionObject")
    end

    it "returns the profile type for cataloging" do
      expect(
        Lookup.profile_type("cataloging")
      ).to eq "Procedures"
    end

    it "returns the profile type for person correctly" do
      expect(
        Lookup.profile_type("person")
      ).to eq "Authorities"
    end

    it "returns the record class" do
      expect(
        Lookup.record_class("Acquisition")
      ).to eq CollectionSpace::Converter::Default::Acquisition
    end
  end
end
