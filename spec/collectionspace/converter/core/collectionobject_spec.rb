require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreCollectionObject do
  let(:attributes) { get_attributes('core', 'cataloging_core_excerpt.csv') }
  let(:corecollectionobject) { CoreCollectionObject.new(attributes) }
  let(:doc) { Nokogiri::XML(corecollectionobject.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_collectionobject.xml') }
  let(:xpaths) {[
    '/document/*/objectNumber',
    '/document/*/numberOfObjects',
    '/document/*/titleGroupList/titleGroup/title',
    { xpath: '/document/*/titleGroupList/titleGroup/titleLanguage',  transform: ->(text) { text.gsub!(/urn:.*?item:name\([^)]+\)'([^']+)'/, '\1') } },
    '/document/*/titleGroupList/titleGroup/titleType',
    '/document/*/titleGroupList/titleGroup/titleTranslationSubGroupList/titleTranslationSubGroup/titleTranslation',
    { xpath: '/document/*/titleGroupList/titleGroup/titleTranslationSubGroupList/titleTranslationSubGroup/titleTranslationLanguage',
    transform: ->(text) { text.gsub!(/urn:.*?item:name\([^)]+\)'([^']+)'/, '\1') } },
    '/document/*/collection',
    '/document/*/objectNameList/objectNameGroup/objectName',
    '/document/*/objectNameList/objectNameGroup/objectNameType',
    '/document/*/objectNameList/objectNameGroup/objectNameSystem',
    '/document/*/objectNameList/objectNameGroup/objectNameCurrency',
    '/document/*/objectNameList/objectNameGroup/objectNameNote',
    '/document/*/objectNameList/objectNameGroup/objectNameLevel',
    { xpath: '/document/*/objectNameList/objectNameGroup[1]/objectNameLanguage', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectNameList/objectNameGroup[1]/objectNameLanguage', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/objectNameList/objectNameGroup[2]/objectNameLanguage', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectNameList/objectNameGroup[2]/objectNameLanguage', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/briefDescriptions/briefDescription',
    '/document/*/responsibleDepartments/responsibleDepartment',
    '/document/*/recordStatus',
    '/document/*/comments/comment',
    '/document/*/fieldColEventNames/fieldColEventName',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSummary',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/dimension',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/value',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/measurementUnit',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/valueQualifier',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/valueDate',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/measurementMethod',
    '/document/*/measuredPartGroupList/measuredPartGroup/measuredPart',
    '/document/*/copyNumber',
    '/document/*/editionNumber',
    '/document/*/forms/form',
    '/document/*/objectStatusList/objectStatus',
    '/document/*/otherNumberList/otherNumber/numberValue',
    '/document/*/otherNumberList/otherNumber/numberType',
    { xpath: '/document/*/inventoryStatusList/inventoryStatus',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/publishToList/publishTo',  transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/assocPeopleGroupList/assocPeopleGroup/assocPeople',
    '/document/*/assocPeopleGroupList/assocPeopleGroup/assocPeopleType',
    '/document/*/assocPeopleGroupList/assocPeopleGroup/assocPeopleNote',
    '/document/*/phase',
    '/document/*/sex',
    '/document/*/objectProductionNote',
    '/document/*/fieldCollectionNote',
    '/document/*/fieldCollectionFeature',
    '/document/*/styles/style',
    '/document/*/technicalAttributeGroupList/technicalAttributeGroup/technicalAttribute',
    '/document/*/technicalAttributeGroupList/technicalAttributeGroup/technicalAttributeMeasurementUnit',
    '/document/*/technicalAttributeGroupList/technicalAttributeGroup/technicalAttributeMeasurement',
    '/document/*/objectComponentGroupList/objectComponentGroup/objectComponentName',
    '/document/*/objectComponentGroupList/objectComponentGroup/objectComponentInformation',
    #'/document/*/objectProductionDateGroupList/objectProductionDateGroup',
    { xpath: '/document/*/objectProductionPersonGroupList/objectProductionPersonGroup[1]/objectProductionPerson',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectProductionPersonGroupList/objectProductionPersonGroup[1]/objectProductionPerson',  transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/objectProductionPersonGroupList/objectProductionPersonGroup[2]/objectProductionPerson',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectProductionPersonGroupList/objectProductionPersonGroup[2]/objectProductionPerson',  transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/objectProductionPersonGroupList/objectProductionPersonGroup/objectProductionPersonRole',
    { xpath: '/document/*/contentPersons/contentPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/contentPeoples/contentPeople',
    '/document/*/contentPlaces/contentPlace',
    '/document/*/contentScripts/contentScript',
    { xpath: '/document/*/contentOrganizations/contentOrganization', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentInscriber', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentMethod',
    { xpath: '/document/*/objectProductionOrganizationGroupList/objectProductionOrganizationGroup[1]/objectProductionOrganization',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectProductionOrganizationGroupList/objectProductionOrganizationGroup[1]/objectProductionOrganization',  transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/objectProductionOrganizationGroupList/objectProductionOrganizationGroup[2]/objectProductionOrganization',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectProductionOrganizationGroupList/objectProductionOrganizationGroup[2]/objectProductionOrganization',  transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/objectProductionOrganizationGroupList/objectProductionOrganizationGroup/objectProductionOrganizationRole',
    '/document/*/techniqueGroupList/techniqueGroup/technique',
    '/document/*/techniqueGroupList/techniqueGroup/techniqueType',
    '/document/*/objectProductionPeopleGroupList/objectProductionPeopleGroup/objectProductionPeople',
    '/document/*/objectProductionPeopleGroupList/objectProductionPeopleGroup/objectProductionPeopleRole',
    '/document/*/objectProductionPlaceGroupList/objectProductionPlaceGroup/objectProductionPlace',
    '/document/*/objectProductionPlaceGroupList/objectProductionPlaceGroup/objectProductionPlaceRole',
    '/document/*/distinguishingFeatures',
    '/document/*/contentEventNameGroupList/contentEventNameGroup/contentEventName',
    '/document/*/contentEventNameGroupList/contentEventNameGroup/contentEventNameType',
    '/document/*/contentOtherGroupList/contentOtherGroup/contentOtherType',
    '/document/*/contentOtherGroupList/contentOtherGroup/contentOther',
    '/document/*/contentDescription',
    { xpath: '/document/*/contentLanguages/contentLanguage[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/contentLanguages/contentLanguage[1]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/contentLanguages/contentLanguage[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/contentLanguages/contentLanguage[2]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/contentActivities/contentActivity',
    { xpath: '/document/*/contentConcepts/contentConcept', transform: ->(text) { CSURN.parse(text)[:label] } },
    #'/document/*/contentDateGroup',
    '/document/*/contentPositions/contentPosition',
    '/document/*/contentObjectGroupList/contentObjectGroup/contentObjectType',
    '/document/*/contentObjectGroupList/contentObjectGroup/contentObject',
    '/document/*/contentNote',
    { xpath: '/document/*/ageQualifier', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/age',
    '/document/*/ageUnit',
    { xpath: '/document/*/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentInscriber', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentMethod',
    '/document/*/materialGroupList/materialGroup/materialName',
    '/document/*/materialGroupList/materialGroup/material',
    '/document/*/materialGroupList/materialGroup/materialComponent',
    '/document/*/materialGroupList/materialGroup/materialComponentNote',
    '/document/*/materialGroupList/materialGroup/materialSource',
    '/document/*/physicalDescription',
    '/document/*/colors/color',
    '/document/*/objectProductionReasons/objectProductionReason',
    '/document/*/assocActivityGroupList/assocActivityGroup/assocActivity',
    '/document/*/assocActivityGroupList/assocActivityGroup/assocActivityType',
    '/document/*/assocActivityGroupList/assocActivityGroup/assocActivityNote',
    '/document/*/assocObjectGroupList/assocObjectGroup/assocObject',
    '/document/*/assocObjectGroupList/assocObjectGroup/assocObjectNote',
    '/document/*/assocObjectGroupList/assocObjectGroup/assocObjectType',
    { xpath: '/document/*/assocConceptGroupList/assocConceptGroup[1]/assocConcept', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocConceptGroupList/assocConceptGroup[1]/assocConcept', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocConceptGroupList/assocConceptGroup[2]/assocConcept', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocConceptGroupList/assocConceptGroup[2]/assocConcept', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/assocConceptGroupList/assocConceptGroup/assocConceptNote',
    '/document/*/assocConceptGroupList/assocConceptGroup/assocConceptType',
    '/document/*/assocCulturalContextGroupList/assocCulturalContextGroup/assocCulturalContextNote',
    '/document/*/assocCulturalContextGroupList/assocCulturalContextGroup/assocCulturalContext',
    '/document/*/assocCulturalContextGroupList/assocCulturalContextGroup/assocCulturalContextType',
    { xpath: '/document/*/assocOrganizationGroupList/assocOrganizationGroup[1]/assocOrganization', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocOrganizationGroupList/assocOrganizationGroup[1]/assocOrganization', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocOrganizationGroupList/assocOrganizationGroup[2]/assocOrganization', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocOrganizationGroupList/assocOrganizationGroup[2]/assocOrganization', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/assocOrganizationGroupList/assocOrganizationGroup/assocOrganizationType',
    '/document/*/assocOrganizationGroupList/assocOrganizationGroup/assocOrganizationNote',
    '/document/*/assocPersonGroupList/assocPersonGroup/assocPersonNote',
    '/document/*/assocPersonGroupList/assocPersonGroup/assocPersonType',
    { xpath: '/document/*/assocPersonGroupList/assocPersonGroup[1]/assocPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocPersonGroupList/assocPersonGroup[1]/assocPerson', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocPersonGroupList/assocPersonGroup[2]/assocPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocPersonGroupList/assocPersonGroup[2]/assocPerson', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/assocPlaceGroupList/assocPlaceGroup/assocPlaceNote',
    '/document/*/assocPlaceGroupList/assocPlaceGroup/assocPlace',
    '/document/*/assocPlaceGroupList/assocPlaceGroup/assocPlaceType',
    '/document/*/assocEventName',
    '/document/*/assocEventNameType',
    { xpath: '/document/*/assocEventOrganizations/assocEventOrganization[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocEventOrganizations/assocEventOrganization[1]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocEventOrganizations/assocEventOrganization[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocEventOrganizations/assocEventOrganization[2]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/assocEventPeoples/assocEventPeople',
    { xpath: '/document/*/assocEventPersons/assocEventPerson[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocEventPersons/assocEventPerson[1]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocEventPersons/assocEventPerson[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocEventPersons/assocEventPerson[2]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/assocEventPlaces/assocEventPlace',
    '/document/*/assocEventNote',
    '/document/*/assocDateGroupList/assocDateGroup/assocStructuredDateGroup/dateDisplayDate',
    '/document/*/assocDateGroupList/assocDateGroup/assocDateNote',
    '/document/*/assocDateGroupList/assocDateGroup/assocDateType',
    '/document/*/objectHistoryNote',
    '/document/*/usageGroupList/usageGroup/usageNote',
    '/document/*/usageGroupList/usageGroup/usage',
    { xpath: '/document/*/owners/owner', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/ownershipAccess',
    '/document/*/ownershipCategory',
    '/document/*/ownershipPlace',
    #'/document/*/ownershipDateGroupList/ownershipDateGroup',
    '/document/*/ownershipExchangeMethod',
    '/document/*/ownershipExchangeNote',
    { xpath: '/document/*/ownershipExchangePriceCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/ownershipExchangePriceValue',
    '/document/*/ownersPersonalExperience',
    '/document/*/ownersPersonalResponse',
    '/document/*/ownersReferences/ownersReference',
    '/document/*/ownersContributionNote',
    '/document/*/viewersRole',
    '/document/*/viewersPersonalExperience',
    '/document/*/viewersPersonalResponse',
    '/document/*/viewersReferences/viewersReference',
    '/document/*/viewersContributionNote',
    { xpath: '/document/*/referenceGroupList/referenceGroup[1]/reference',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/referenceGroupList/referenceGroup[1]/reference',  transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/referenceGroupList/referenceGroup[2]/reference',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/referenceGroupList/referenceGroup[2]/reference',  transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/referenceGroupList/referenceGroup/referenceNote',
    #'/document/*/fieldCollectionDateGroup',
    { xpath: '/document/*/fieldCollectionMethods/fieldCollectionMethod', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectionPlace', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource[1]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource[2]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[1]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[2]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/fieldCollectionNumber',
    '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescription',
    { xpath: '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup[1]/inscriptionDescriptionInscriber', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup[1]/inscriptionDescriptionInscriber', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup[2]/inscriptionDescriptionInscriber', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup[2]/inscriptionDescriptionInscriber', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionDateGroup/dateDisplayDate',
    '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionPosition',
    '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionType',
    '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionMethod',
    '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionInterpretation',
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'cataloging_core_excerpt.csv', 102) }
    let(:corecollectionobject) { CoreCollectionObject.new(attributes) }
    let(:doc) { Nokogiri::XML(corecollectionobject.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_collectionobject_row102.xml') }
    let(:xpath_required) {[
      '/document/*/objectNumber'
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end

end
