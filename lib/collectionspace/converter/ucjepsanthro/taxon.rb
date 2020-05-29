# frozen_string_literal: true

module CollectionSpace
  module Converter
    module UCJEPSAnthro
      class UCJEPSAnthroTaxon < Taxon 
        ::UCJEPSAnthroTaxon = CollectionSpace::Converter::UCJEPSAnthro::UCJEPSAnthroTaxon
        def convert 
          run do |xml|
            UCJEPSAnthroTaxon.map(xml, attributes, config)
          end
        end

        def self.map(xml, attributes, config)
          CSXML.add xml, 'shortidentifier', config[:identifier]
          CSXML.add xml, 'taxonIsNamedHybrid' => attributes['taxonIsNamedHybrid']
          CSXML.add xml, 'taxonRank' => attributes['taxonRank']
          CSXML.add xml, 'taxonYear' => attributes['taxonYear']
          CSXML.add xml, 'taxonCurrency' => attributes['taxonCurrency']
          CSXML.add_group_list xml, 'taxonTerm',[
            {
              'termName' => attributes['taxon'],
              'termSource' => attributes['termSource'],
              'termSourceID' => attributes['termSourceID'],
              'taxonomicStatus' => 'accepted',
              'termSourceNote' => attributes['termsourcenote'],
              'termLanguage' => CSXML::Helpers.get_vocab('languages', attributes['termlanguage']),
              'termPrefForLang' => attributes.fetch('termprefforlang', '').downcase,
              # 'termDisplayName' => attributes['taxon'],
              'termDisplayName' => attributes['termDisplayName'],
              'termType' => attributes['descriptor'],
              'termStatus' => attributes['termstatus'],
              'termQualifier' => attributes['termqualifier'],
              'termSourceDetail' => attributes['termsourcedetail']
            }
          ]
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'taxonCitation',
            ['taxonCitation' => 'taxonCitation']
          )
          CSXML.add_group_list xml, 'commonName', [
            {
              'commonName' => attributes['commonName'],
              'commonNameLanguage' => attributes['commonNameLanguage'],
              'commonNameSource' => attributes['commonNameSource'],
              'commonNameSourceDetail' => attributes['commonNameSource']
            }
          ]
          CSXML.add_group_list xml, 'taxonAuthor', [
            {
              'taxonAuthor' => attributes['taxonAuthor'],
              'taxonAuthorType' => attributes['taxonAuthorType']
            }
          ]
          # Natural History starts here
          CSXML.add_group_list xml, 'plantAttributes', [
            {
              'attributeDate' => attributes['attributeDate'],
              'recordedBy' => attributes['recordedBy'],
              'height' => attributes['height'],
              'width' => attributes['width'],
              'diameterBreastHeight' => attributes['diameterBreastHeight'],
              'habitat' => attributes['habitat'],
              'climateRating' => attributes['climateRating'],
              'conservationCategory' => attributes['conservationCategory'],
              'conservationOrganization' => attributes['conservationOrganization'],
              'frostSensitive' => attributes['frostSensitive'],
              'medicinalUse' => attributes['medicinalUse'],
              'economicUse' => attributes['economicUse']
            }
          ]
          CSXML.add_group_list xml, 'naturalHistoryCommonName', [
            {
              'naturalHistoryCommonName' => attributes['naturalHistoryCommonName'],
              'naturalHistoryCommonNameLanguage' => attributes['naturalHistoryCommonNameLanguage'],
              'naturalHistoryCommonNameSource' => attributes['naturalHistoryCommonNameSource'],
              'naturalHistoryCommonNameSourceDetail' => attributes['naturalHistoryCommonNameSourceDetail'],
              'naturalHistoryCommonNameType' => attributes['naturalHistoryCommonNameType']
            }
          ]
          CSXML.add xml, 'family' => attributes['taxon_naturalhistory/family']
          # CSXML.add_group_list xml, 'relatedTerm', [
          #   {
          #     'relatedTerm' => attributes['relatedTerm'],
          #     'relatedTermType' => attributes['relatedTermType'],
          #     'relatedTermSource' => attributes['relatedTermSource'],
          #     'relatedTermSourceDetail' => attributes['relatedTermSourceDetail']
          #   }
          # ]
          # UCJEPS Taxon
          CSXML.add xml, 'taxonBasionym' => attributes['taxon_ucjeps/taxonBasionym']
          CSXML.add xml, 'taxonMajorGroup' => attributes['taxon_ucjeps/taxonMajorGroup']
        end
      end
    end
  end
end
