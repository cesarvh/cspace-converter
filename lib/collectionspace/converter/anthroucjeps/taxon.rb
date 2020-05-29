# frozen_string_literal: true

module CollectionSpace
  module Converter
    module AnthroUcjeps
      class AnthroUcjepsTaxon < Taxon
        ::AnthroUcjepsTaxon = CollectionSpace::Converter::AnthroUcjeps::AnthroUcjepsTaxon
        def convert
          run(wrapper: 'document') do |xml| 
            xml.send(
              'ns2:taxon_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/taxonomy',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              AnthroUcjepsTaxon.map(xml, attributes, config)
            end

            # xml.send(
            #   'ns2:taxon_ucjeps',
            #   'xmlns:ns2' => 'http://collectionspace.org/services/taxon/local/ucjeps',
            #   'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance"'
            # ) do 
            #   xml.parent.namespace = nil
            #   AnthroUcjepsTaxon.map_ucjeps(xml, attributes)
            # end

            # xml.send(
            #   'ns2:taxon_naturalhistory',
            #   'xmlns:ns2' => 'http://collectionspace.org/services/taxon/domain/naturalhistory',
            #   'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            # ) do 
            #   xml.parent.namespace = nil
            #   AnthroUcjepsTaxon.extension(xml, attributes)
            # end
          end
        end
        
        def self.map(xml, attributes, config)
          CSXML.add xml, 'shortidentifier', config[:identifier] 
          pairs = {
            'taxonIsNamedHybrid' => 'taxonIsNamedHybrid',
            'taxonRank' => 'taxonRank',
            'taxonYear' => 'taxonYear',
            'taxonCurrency' => 'taxonCurrency'
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, {})
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
        end
        
        # def self.map_ucjeps(xml, attributes) 
        #   CSXML.add xml, 'taxonBasionym' => attributes['taxon_ucjeps/taxonBasionym']
        #   CSXML.add xml, 'taxonMajorGroup' => attributes['taxon_ucjeps/taxonMajorGroup']
        # end

        # def self.extension(xml, attributes)
        #   # TO DO
        #   CSXML.add_group_list xml, 'plantAttributes', [
        #     {
        #       'attributeDate' => attributes['attributeDate'],
        #       'recordedBy' => attributes['recordedBy'],
        #       'height' => attributes['height'],
        #       'width' => attributes['width'],
        #       'diameterBreastHeight' => attributes['diameterBreastHeight'],
        #       'habitat' => attributes['habitat'],
        #       'climateRating' => attributes['climateRating'],
        #       'conservationCategory' => attributes['conservationCategory'],
        #       'conservationOrganization' => attributes['conservationOrganization'],
        #       'frostSensitive' => attributes['frostSensitive'],
        #       'medicinalUse' => attributes['medicinalUse'],
        #       'economicUse' => attributes['economicUse']
        #     }
        #   ]
        #   CSXML.add_group_list xml, 'naturalHistoryCommonName', [
        #     {
        #       'naturalHistoryCommonName' => attributes['naturalHistoryCommonName'],
        #       'naturalHistoryCommonNameLanguage' => attributes['naturalHistoryCommonNameLanguage'],
        #       'naturalHistoryCommonNameSource' => attributes['naturalHistoryCommonNameSource'],
        #       'naturalHistoryCommonNameSourceDetail' => attributes['naturalHistoryCommonNameSourceDetail'],
        #       'naturalHistoryCommonNameType' => attributes['naturalHistoryCommonNameType']
        #     }
        #   ]
        #   CSXML.add xml, 'family' => attributes['taxon_naturalhistory/family']
        #   # CSXML.add_group_list xml, 'relatedTerm', [
        #   #   {
        #   #     'relatedTerm' => attributes['relatedTerm'],
        #   #     'relatedTermType' => attributes['relatedTermType'],
        #   #     'relatedTermSource' => attributes['relatedTermSource'],
        #   #     'relatedTermSourceDetail' => attributes['relatedTermSourceDetail']
        #   #   }
        #   # ]
        # end
      end
    end
  end
end
