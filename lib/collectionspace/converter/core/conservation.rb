module CollectionSpace
  module Converter
    module Core
      class CoreConservation < Conservation
        ::CoreConservation = CollectionSpace::Converter::Core::CoreConservation
        def convert
          run do |xml|
            CoreConservation.map(xml, attributes)
          end
        end

        def self.pairs
          {
            'conservationnumber' => 'conservationNumber',
            'treatmentpurpose' => 'treatmentPurpose',
            'fabricationnote' => 'fabricationNote',
            'proposedtreatment' => 'proposedTreatment',
            'approvedby' => 'approvedBy',
            'approveddate' => 'approvedDate',
            'treatmentstartdate' => 'treatmentStartDate',
            'treatmentenddate' => 'treatmentEndDate',
            'treatmentsummary' => 'treatmentSummary',
            'proposedanalysis' => 'proposedAnalysis',
            'researcher' => 'researcher',
            'proposedanalysisdate' => 'proposedAnalysisDate',
            'analysismethod' => 'analysisMethod',
            'analysisresults' => 'analysisResults'
          }
        end

        def self.repeats
          { 
            'conservator' => ['conservators', 'conservator']
          }
        end
 

        def self.map(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, CoreConservation.pairs,
          pairstransforms = {
            'treatmentpurpose' => {'vocab' => 'treatmentpurpose'},
            'approvedby' => {'authority' => ['personauthorities', 'person']},
            'approveddate' => {'special' => 'unstructured_date_stamp'},
            'treatmentstartdate' => {'special' => 'unstructured_date_stamp'},
            'treatmentenddate' => {'special' => 'unstructured_date_stamp'},
            'researcher' => {'authority' => ['personauthorities', 'person']},
            'proposedanalysisdate' => {'special' => 'unstructured_date_stamp'}
          })
          CSXML::Helpers.add_repeats(xml, attributes, CoreConservation.repeats,
          repeatstransforms = {
            'conservator' => {'authority' => ['personauthorities', 'person']}
          })
          conservation_status = {
            'status' => 'status',
            'statusdate' => 'statusDate'
          }
          conservation_statustransforms = {
            'status' => {'vocab' => 'conservationstatus'},
            'statusdate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'conservationStatus',
            conservation_status,
            conservation_statustransforms
          )
          other_party = { 
            'otherparty' => 'otherParty',
            'otherpartyrole' => 'otherPartyRole',
            'otherpartynote' => 'otherPartyNote'
          }
          other_partytransforms = {
            'otherparty' => {'authority' => ['personauthorities', 'person']},
            'otherpartyrole' => {'vocab' => 'otherpartyrole'}
          }
          CSXML.add_single_level_group_list( 
            xml,
            attributes,
            'otherParty',
            other_party,
            other_partytransforms
          )
          overall_examination = {        
            'examinationstaff' => 'examinationStaff',
            'examinationphase' => 'examinationPhase',
            'examinationdate' => 'examinationDate',
            'examinationnote' => 'examinationNote'
          }
          examinationtransforms = {
            'examinationstaff' => {'authority' => ['personauthorities', 'person']},
            'examinationdate' => {'special' => 'unstructured_date_stamp'},
            'examinationphase' => {'vocab' => 'examinationphase'}
          }
          CSXML.add_single_level_group_list( 
            xml,
            attributes,
            'examination',
            overall_examination,
            examinationtransforms
          )
          dest = {
            'sampleby' => 'sampleBy',
            'destanalysisapprovalnote' => 'destAnalysisApprovalNote',
            'sampledescription' => 'sampleDescription',
            'destanalysisapproveddate' => 'destAnalysisApprovedDate',
            'sampledate' => 'sampleDate',
            'samplereturned' => 'sampleReturned',
            'samplereturnedlocation' => 'sampleReturnedLocation'
          }
          desttransforms = {
            'sampleby' => {'authority' => ['personauthorities', 'person']},
            'destanalysisapproveddate' => {'special' => 'unstructured_date_stamp'},
            'sampledate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list( 
            xml,
            attributes,
            'destAnalysis',
            dest,
            desttransforms
          )
        end
      end
    end
  end
end

