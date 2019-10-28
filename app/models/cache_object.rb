class CacheObject
  include Mongoid::Document
  validates_uniqueness_of :key

  before_validation :setup

  field :uri,        type: String
  field :refname,    type: String
  field :name,       type: String
  field :identifier, type: String
  field :type,       type: String
  field :subtype,    type: String
  field :key,        type: String
  field :updated_at, type: DateTime

  # parent vocabulary
  field :parent_uri,        type: String
  field :parent_updated_at, type: String

  def setup
    type    = CSURN.parse_type(refname)
    subtype = CSURN.parse_subtype(refname)
    key     = AuthCache.cache_key([type, subtype, name])
    write_attribute :type, type
    write_attribute :subtype, subtype
    write_attribute :key, key
  end

  def skip_item?(item)
    false
  end

  def skip_list?(list)
    false
  end
end
