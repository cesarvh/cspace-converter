module CollectionSpace
  module Converter
    module Core
      class CoreObjectExit < ObjectExit
        ::CoreObjectExit = CollectionSpace::Converter::Core::CoreObjectExit
        def convert
          run do |xml|
            CoreObjectExit.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'exitNumber', attributes["exit_number"]
          CSXML.add_group xml, 'exitDate', { "dateDisplayDate" => attributes['exit_display_date'],
            'dateEarliestSingleYear' => attributes['exit_earliest_/_single_date_year'],
            'dateEarliestSingleMonth' => attributes['exit_earliest_/_single_date_month'],
            'dateEarliestSingleDay' => attributes['exit_earliest_/_single_date_day'],
            'dateLatestYear' => attributes['exit_latest_date_year'],
            'dateLatestMonth' => attributes['exit_latest_date_month'],
            'dateLatestDay' => attributes['exit_latest_date_day'],
          }
          CSXML::Helpers.add_organization xml, 'currentOwner', attributes["current_owner"]
          CSXML.add xml, 'exitNote', attributes["exit_note"]
        end
      end
    end
  end
end
