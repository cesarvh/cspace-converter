# frozen_string_literal: true

module CollectionSpace
  module Converter
    module Extension
      # Cultural Care Extension
      module Commission
        ::Commission = CollectionSpace::Converter::Extension::Commission
        def self.map_commission(xml, attributes)
          #commissionDate
          CSXML::Helpers.add_date_group(xml, 'commissionDate', CSDTP.parse(attributes['commissiondate']), suffix = '')
          repeats = { 
            'commissioningbodyperson' => ['commissioningBodyList', 'commissioningBody'],
            'commissioningbodyorganization' => ['commissioningBodyList', 'commissioningBody']
          }
          repeatstransforms = {
            'commissioningbodyperson' => {'authority' => ['personauthorities', 'person']},
            'commissioningbodyorganization' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
          #commissionBudgetGroupList, commissionBudgetGroup
          commision_data = {
            'commissionprojectedvaluecurrency' => 'commissionProjectedValueCurrency',
            'commissionactualvalueamount' => 'commissionActualValueAmount',
            'commissionbudgettypenote' => 'commissionBudgetTypeNote',
            'commissionprojectedvalueamount' => 'commissionProjectedValueAmount',
            'commissionactualvaluecurrency' => 'commissionActualValueCurrency',
            'commissionbudgettype' => 'commissionBudgetType',
          }
          commission_transforms = {
            'commissionprojectedvaluecurrency' => {'vocab' => 'currency'},
            'commissionactualvaluecurrency' => {'vocab' => 'currency'},
            'commissionbudgettype' => {'vocab' => 'budgettype'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'commissionBudget',
            commision_data,
            commission_transforms
          )
        end
      end
    end
  end
end
