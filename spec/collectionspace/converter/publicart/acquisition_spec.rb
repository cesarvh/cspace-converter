require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtAcquisition do
  let(:attributes) { get_attributes('publicart', 'acquisition_publicart.csv') }
  let(:publicartacquisition) { PublicArtAcquisition.new(Lookup.profile_defaults('acquisition').merge(attributes)) }
  let(:doc) { get_doc(publicartacquisition) }
  let(:record) { get_fixture('publicart_acquisition.xml') }

  describe 'map_common' do
    p = 'acquisitions_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/transferOfTitleNumber",
        "/document/#{p}/groupPurchasePriceCurrency",
        "/document/#{p}/groupPurchasePriceValue",
        "/document/#{p}/objectOfferPriceCurrency",
        "/document/#{p}/objectOfferPriceValue",
        "/document/#{p}/objectPurchaseOfferPriceCurrency",
        "/document/#{p}/objectPurchaseOfferPriceValue",
        "/document/#{p}/objectPurchasePriceCurrency",
        "/document/#{p}/objectPurchasePriceValue",
        "/document/#{p}/originalObjectPurchasePriceCurrency",
        "/document/#{p}/originalObjectPurchasePriceValue",
        "/document/#{p}/approvalGroupList/approvalGroup/approvalGroup",
        "/document/#{p}/approvalGroupList/approvalGroup/approvalIndividual",
        "/document/#{p}/approvalGroupList/approvalGroup/approvalStatus",
        "/document/#{p}/approvalGroupList/approvalGroup/approvalDate",
        "/document/#{p}/approvalGroupList/approvalGroup/approvalNote",
        "/document/#{p}/acquisitionProvisos",
        "/document/#{p}/fieldCollectionEventNames/fieldCollectionEventName",
        "/document/#{p}/accessionDateGroup/dateDisplayDate",
        "/document/#{p}/acquisitionDateGroupList/acquisitionDateGroup/dateDisplayDate",
      ].each do |xpath|
        context "xpath: #{xpath}" do
          it 'is empty' do
            expect(get_text(doc, xpath)).to be_empty
          end
        end
      end
    end

    context 'fields overridden by publicart' do
      context 'authority/vocab fields' do
        [
          "/document/#{p}/owners/owner",
          "/document/#{p}/acquisitionSources/acquisitionSource",
          "/document/#{p}/acquisitionMethod",
          "/document/#{p}/acquisitionFundingList/acquisitionFunding/acquisitionFundingCurrency",
          "/document/#{p}/acquisitionFundingList/acquisitionFunding/acquisitionFundingSource"
        ].each do |xpath|
          context "#{xpath}" do
            let(:docurns) { urn_values(doc, xpath) }
            it 'is not empty' do
              expect(get_text(doc, xpath)).to_not be_empty
            end

            it 'values are URNs' do
              expect(docurns).not_to include('not a urn')
            end
            
            it 'URNs match sample payload' do
              expect(docurns).to eq(urn_values(record, xpath))
            end
          end
        end
      end

      context 'non-authority/vocab fields in group(s) with overridden field(s)' do
        [
          "/document/#{p}/acquisitionFundingList/acquisitionFunding/acquisitionFundingValue",
          "/document/#{p}/acquisitionFundingList/acquisitionFunding/acquisitionFundingSourceProvisos"
        ].each do |xpath|
          context "#{xpath}" do
            let(:doctext) { get_text(doc, xpath) }
            it 'is not empty' do
              expect(doctext).to_not be_empty
            end
            
            it 'matches sample payload' do
              expect(doctext).to eq(get_text(record, xpath))
            end
          end
        end
      end
    end
  end

  describe 'map_publicart' do
    pa = 'acquisitions_publicart'
    context 'non-authority/vocab fields' do
      [
        "/document/#{pa}/accessionDate",
        "/document/#{pa}/acquisitionDates/acquisitionDate",
      ].each do |xpath|
        context "#{xpath}" do
          let(:doctext) { get_text(doc, xpath) }
          it 'is not empty' do
            expect(doctext).to_not be_empty
          end
          
          it 'matches sample payload' do
            expect(doctext).to eq(get_text(record, xpath))
          end
        end
      end
    end
  end

  describe 'map_commission' do
    # since we are not overriding anything in this extension, test coverage
    #  is in extension/commission_spec.rb
  end
end
