module CollectionSpace
  module Tools
    module Identifiers
      ::CSIDF = CollectionSpace::Tools::Identifiers

      def self.authority_term_type(authority)
        authority = authority.downcase
        # not all authorities use the full name in the term type i.e. orgTermGroupList
        term_types = {
            "location" => "loc",
            "organization" => "org",
        }
        term_types.fetch(authority, authority)
      end

      # given a vocab option value convert to id form, for example:
      # "Growing on a rock Bonsai style (Seki-joju)" => "growing_on_a_rock_bonsai_style_seki_joju"
      def self.for_option(option, strip = false)
        option = option.strip if strip
        option.downcase.
            gsub(/[()'"]/, '').
            gsub(' - ', '_').
            gsub('/', '_').
            gsub('-', '_').
            gsub(' ', '_')
      end

      def self.short_identifier(value)
        v = value.gsub(/\W/, '')
        "#{v}#{XXhash.xxh32(v)}"
      end
    end
  end
end
