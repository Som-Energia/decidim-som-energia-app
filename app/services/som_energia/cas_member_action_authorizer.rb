# frozen_string_literal: true

module SomEnergia
  class CasMemberActionAuthorizer < Decidim::Verifications::DefaultActionAuthorizer
    protected

    def unmatched_fields
      return [] if options["member_type"] == "any"

      super
    end
  end
end
