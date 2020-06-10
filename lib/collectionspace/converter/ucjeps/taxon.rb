module CollectionSpace
  module Converter
    module UCJEPS
      class UCJEPSTaxon < AnthroTaxon
        ::UCJEPSTaxon = CollectionSpace::Converter::UCJEPS::UCJEPSTaxon
        def convert 
          run(wrapper: 'document') do |xml| 
            xml.send(
              "ns2:taxon_common",
              "xmlns:ns2" => "http://collectionspace.org/services/taxonomy",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
             ) do 
              xml.parent.namespace = nil
              UCJEPSTaxon.map(xml, attributes, redefined_fields)
            end # send common

            xml.send(
              "ns2:taxon_ucjeps",
              "xmlns:ns2" => "http://collectionspace.org/services/taxon/local/ucjeps",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
              ) do 
                xml.parent.namespace = nil
                UCJEPSTaxon.map_ucjeps(xml, attributes)
            end # send taxon_ucjeps

            xml.send(
                'ns2:taxon_naturalhistory',
                'xmlns:ns2' => 'http://collectionspace.org/services/taxon/domain/naturalhistory',
                'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
              ) do 
                xml.parent.namespace = nil
                UCJEPSTaxon.map_extension(xml, attributes)
            end # sent nat hist taxon
          end # run 
        end # convert
        
        def redefined_fields
          @redefined.concat([])
          super
        end # redefined fields

        def self.map(xml, attributes, redefined) 
          AnthroTaxon.map(xml, attributes, redefined)
        
        end # map

        def self.map_ucjeps(xml, attributes) 
          pairs = {
            'taxonmajorgroup' => 'taxonMajorGroup'
          }
          pairs_transforms = {
            'taxonmajorgroup' => {'vocab' => 'taxonmajorgroups'}, 
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
        end # map ucjeps
        
        def self.map_extension(xml, attributes)
          pairs = {
            'taxonbasionym' => 'taxonBasionym',
            'family' => 'family'
          }

          pairs_transforms = {
            'taxonbasionym' => {'authority' => ['taxonauthorities', 'taxon']},
            'family' => {'authority' => ['taxonauthorities', 'taxon']}
          }

          # 'oaicollectionplace' => {'authority' => ['placeauthorities', 'place']}
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
          
          # related term group list

          relatedterm_data = {
            'relatedterm' => 'relatedTerm',
            'relatedtermtype' => 'relatedTermType',
            'relatedtermsource' => 'relatedTermSource',
            'relatedtermsourcedetail' => 'relatedTermSourceDetail'
          }

          relatedterm_transforms = {
            'relatedterm' => {'authority' => ['taxonauthorities', 'taxon']}, 
            'relatedtermtype' => {'vocab' => 'taxonrelatedtermtypes'}
          }

          CSXML.add_single_level_group_list(xml, attributes, 'relatedTerm', relatedterm_data, relatedterm_transforms)


        #   <Field name="relatedTermGroupList" subpath="ns2:taxon_naturalhistory">
        #   <Field name="relatedTermGroup">
        #     <Field name="relatedTerm" />
        #     <Field name="relatedTermType" />
        #     <Field name="relatedTermSource" />
        #     <Field name="relatedTermSourceDetail" />
        #   </Field>
        # </Field>
        end # def extensions




      end # class UCJEPSTaxon
    end # model ucjeps
  end # module Converter
end # module CSpace
