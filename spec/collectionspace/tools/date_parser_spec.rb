require 'rails_helper'

RSpec.describe CSDTP do
  describe '#parse' do
    let(:basic_date) { '2011/11/02' }
    let(:basic_end_date) { '2011/12/05' }
    let(:ca_date) { 'ca. 1915' }
    let(:hyphenated_date) { '1905-1907' }
    let(:usa_date) { '11/02/1980' }
    let(:short_month_or_day_date) { '2010/1/1' }
    let(:ca_date) { 'ca. 1950' }
    let(:text_date) { 'Early 20th century' }

    it "can return an empty date when no date provided" do
      date = CSDTP.parse(nil)
      expect(date.class).to eq CollectionSpace::Tools::StructuredDate
      expect(date.parsed_datetime).to be nil
    end

    context 'when approximate date or textual date string given' do
      let(:ca_date_parsed) { CSDTP.parse(ca_date) }
      let(:text_date_parsed) {CSDTP.parse(text_date) }
      
      it "returns structured date" do
        expect(ca_date_parsed.class).to eq CollectionSpace::Tools::StructuredDate
        expect(text_date_parsed.class).to eq CollectionSpace::Tools::StructuredDate
      end

      it "scalarValuesComputed = false" do
        expect(ca_date_parsed.computed).to eq 'false'
        expect(text_date_parsed.computed).to eq 'false'
      end
      it "dateDisplayDate = the date string passed in" do
        expect(ca_date_parsed.display_date).to eq(ca_date)
        expect(text_date_parsed.display_date).to eq(text_date)
      end
    end

    it "can parse a basic date" do
      date = CSDTP.parse(basic_date)
      test_base_basic_date(date)
      expect(date.latest_day).to eq 3
      expect(date.latest_month).to eq 11
      expect(date.latest_year).to eq 2011
      expect(date.latest_scalar).to eq '2011-11-03T00:00:00.000Z'
    end

    it "can parse a basic date with end date" do
      date = CSDTP.parse(basic_date, basic_end_date)
      test_base_basic_date(date)
      expect(date.latest_day).to eq 5
      expect(date.latest_month).to eq 12
      expect(date.latest_year).to eq 2011
      expect(date.latest_scalar).to eq '2011-12-05T00:00:00.000Z'
    end

    it "returns an empty date when given a ca date" do
      date = CSDTP.parse(ca_date)
      expect(date.class).to eq CollectionSpace::Tools::StructuredDate
      expect(date.parsed_datetime).to be nil
    end

    it "returns an empty date when given a hyphenated date" do
      date = CSDTP.parse(hyphenated_date)
      expect(date.class).to eq CollectionSpace::Tools::StructuredDate
      expect(date.parsed_datetime).to be nil
    end

    it "can parse a US formatted date" do
      date = CSDTP.parse(usa_date)
      expect(date.earliest_day).to eq 2
      expect(date.earliest_month).to eq 11
      expect(date.earliest_year).to eq 1980
      expect(date.earliest_scalar).to eq '1980-11-02T00:00:00.000Z'
    end

    it "can parse a date with 1-digit month or day" do
      date = CSDTP.parse(short_month_or_day_date)
      expect(date.earliest_day).to eq 1
      expect(date.earliest_month).to eq 1
      expect(date.earliest_year).to eq 2010
      expect(date.earliest_scalar).to eq '2010-01-01T00:00:00.000Z'
    end
  end #describe #parse

  describe '#parse_unstructured_date_stamp' do
    let(:d1) { '2011-11-02' }
    let(:d2) { '2011/3/2' }
    let(:d3) { '2011/03/02' }
    let(:d4) { '11/02/1980' }
    let(:d5) { '3/2/1980' }

    it 'parses 2011-11-02 as 2011-11-02' do
      expect(CSDTP.parse_unstructured_date_stamp(d1)).to eq('2011-11-02T00:00:00.000Z')
    end

    it 'parses 2011/3/2 as 2011-03-02' do
      expect(CSDTP.parse_unstructured_date_stamp(d2)).to eq('2011-03-02T00:00:00.000Z')
    end

    it 'parses 2011/03/02 as 2011-03-02' do
      expect(CSDTP.parse_unstructured_date_stamp(d3)).to eq('2011-03-02T00:00:00.000Z')
    end

    it 'parses 11/02/1980 as 1980-11-02' do
      expect(CSDTP.parse_unstructured_date_stamp(d4)).to eq('1980-11-02T00:00:00.000Z')
    end

    it 'parses 3/2/1980 as 1980-03-02' do
      expect(CSDTP.parse_unstructured_date_stamp(d5)).to eq('1980-03-02T00:00:00.000Z')
    end
  end # describe '#parse_unstructured_date_stamp'
  
  describe '#parse_unstructured_date_string' do
    let(:d1) { '2011-11-02' }
    let(:d2) { '2011/3/2' }
    let(:d3) { '2011/03/02' }
    let(:d4) { '11/02/1980' }
    let(:d5) { '3/2/1980' }

    it 'parses 2011-11-02 as 2011-11-02' do
      expect(CSDTP.parse_unstructured_date_string(d1)).to eq('2011-11-02')
    end

    it 'parses 2011/3/2 as 2011-03-02' do
      expect(CSDTP.parse_unstructured_date_string(d2)).to eq('2011-03-02')
    end

    it 'parses 2011/03/02 as 2011-03-02' do
      expect(CSDTP.parse_unstructured_date_string(d3)).to eq('2011-03-02')
    end

    it 'parses 11/02/1980 as 1980-11-02' do
      expect(CSDTP.parse_unstructured_date_string(d4)).to eq('1980-11-02')
    end

    it 'parses 3/2/1980 as 1980-03-02' do
      expect(CSDTP.parse_unstructured_date_string(d5)).to eq('1980-03-02')
    end
  end # describe '#parse_unstructured_date_string'

  describe '#fields_for' do
    let(:d1) { CSDTP.parse('2011-11-02') }
    let(:result) {
      {"scalarValuesComputed"=>"true",
       "dateDisplayDate"=>"2011-11-02",
       "dateEarliestSingleYear"=>2011,
       "dateEarliestSingleMonth"=>11,
       "dateEarliestSingleDay"=>2,
       "dateEarliestScalarValue"=>"2011-11-02T00:00:00.000Z",
       "dateEarliestSingleEra"=>
         "urn:cspace:core.collectionspace.org:vocabularies:name(dateera):item:name(ce)'CE'",
       "dateLatestYear"=>2011,
       "dateLatestMonth"=>11,
       "dateLatestDay"=>3,
       "dateLatestScalarValue"=>"2011-11-03T00:00:00.000Z",
       "dateLatestEra"=>
         "urn:cspace:core.collectionspace.org:vocabularies:name(dateera):item:name(ce)'CE'"}
    }
    it 'returns hash' do
      expect(CSDTP.fields_for(d1)).to eq(result)
    end
  end
end
