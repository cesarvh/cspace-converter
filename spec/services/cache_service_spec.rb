require 'rails_helper'

RSpec.describe CacheService do
  it "can return registered authorities" do
    expect(CacheService.authorities).to eq(
      Lookup.converter_class.registered_authorities
    )
  end
end
