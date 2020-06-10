module CollectionSpace
  module Converter
    module UCJEPS
      class UCJEPSCollectionObject < AnthroCollectionObject
        ::UCJEPSCollectionObject = CollectionSpace::Converter::UCJEPS::UCJEPSCollectionObject
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              "ns2:collectionobjects_common",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              UCJEPSCollectionObject.map_common(xml, attributes, redefined_fields)
            end

            xml.send(
              "ns2:collectionobjects_anthro",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/anthro",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              UCJEPSCollectionObject.map_anthro(xml, attributes)
            end

            xml.send(
              "ns2:collectionobjects_annotation",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/annotation",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              UCJEPSCollectionObject.map_annotation(xml, attributes)
            end

            xml.send(
              "ns2:collectionobjects_nagpra",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/nagpra",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              UCJEPSCollectionObject.map_nagpra(xml, attributes)
            end

            xml.send(
              "ns2:collectionobjects_ucjeps",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/ucjeps",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              UCJEPSCollectionObject.map_ucjeps(xml, attributes)
            end
          end
        end #def convert

        def redefined_fields
          @redefined.concat([
            # by ohc
            'assocpeople',
            'assocpeopletype',
            'assocpeoplenote',
            'objectnametype',
            'objectnamesystem',
            'objectname',
            'objectnamecurrency',
            'objectnamenote',
            'objectnamelevel',
            'objectnamelanguage',
          ])
          super
        end

        def self.map_common(xml, attributes, redefined)
          AnthroCollectionObject.map_common(xml, attributes, redefined)

          # assocPeopleGroupList , assocPeopleGroup
          assocpeopledata = {
            'assocpeople' => 'assocPeople',
            'assocpeopletype' => 'assocPeopleType',
            'assocpeoplenote' => 'assocPeopleNote'
          }
          aptransform = {
            'assocpeople' => {'authority' => ['conceptauthorities', 'ethculture']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocPeople',
            assocpeopledata,
            aptransform
          )

          # objectNameList, objectNameGroup
          obj_name_data = {
            'objectnametype' => 'objectNameType',
            'objectnamesystem' => 'objectNameSystem',
            'objectname' => 'objectName',
            'objectnamecurrency' => 'objectNameCurrency',
            'objectnamenote' => 'objectNameNote',
            'objectnamelevel' => 'objectNameLevel',
            'objectnamelanguage' => 'objectNameLanguage'
          }
          obj_name_transforms = {
            'objectnamelanguage' => {'vocab' => 'languages'},
            'objectname' => {'authority' => ['conceptauthorities', 'nomenclature']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectName',
            obj_name_data,
            obj_name_transforms,
            list_suffix: 'List'
          )
        end

        # EXTENTIONS
        def self.map_annotation(xml, attributes)
          AnthroCollectionObject.map_annotation(xml, attributes)
        end

        def self.map_anthro(xml, attributes)
          AnthroCollectionObject.map_anthro(xml, attributes)
        end

        def self.map_nagpra(xml, attributes)
          AnthroCollectionObject.map_nagpra(xml, attributes)
        end

        def self.map_ucjeps(xml, attributes)
          pairs = {
            'descriptionlevel' => 'descriptionLevel'
          }
          pair_transforms = {
            'descriptionlevel' => {'vocab' => 'descriptionlevel'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pair_transforms)

          repeats = {
            'namedtimeperiod' => ['namedTimePeriods', 'namedTimePeriod']
          }
          repeat_transforms = {
            'namedtimeperiod' => {'vocab' => 'namedtimeperiods'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)

          #oaiSiteGroupList, oaiSiteGroup
          oai_data = {
            'oaicollectionplace' => 'oaiCollectionPlace',
            'oailocverbatim' => 'oaiLocVerbatim'
          }
          oai_transforms = {
            'oaicollectionplace' => {'authority' => ['placeauthorities', 'place']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'oaiSite',
            oai_data,
            oai_transforms
            )
        end
        
      end #class UCJEPSCollectionObject
    end #module UCJEPS
  end #module Converter
end #module CollectionSpace
