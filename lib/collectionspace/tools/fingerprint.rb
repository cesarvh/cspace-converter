module CollectionSpace
  module Tools
    class Fingerprint
      ::Fingerprint = CollectionSpace::Tools::Fingerprint
      def self.generate(parts)
        Digest::MD5.hexdigest parts.compact.map(&:downcase).join('.')
      end

      class Authority
        def self.parts
          [:type, :subtype, :title]
        end
      end

      class Procedure
        def self.parts
          [:type, :identifier_field, :identifier]
        end
      end

      class Relationship
        def self.parts
          []
        end
      end

      class Vocabulary
        def self.parts
          [:type, :subtype, :title]
        end
      end
    end
  end
end
