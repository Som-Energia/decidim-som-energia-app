# frozen_string_literal: true

require "digest"

module SomEnergia
  class CasMember < Decidim::AuthorizationHandler
    attribute :extended_data
    validate :valid_member

    def form_attributes
      attributes.except("id", "user", "extended_data").keys
    end

    def extended_data
      super || user.try(:extended_data) || {}
    end

    def metadata
      super.merge(**extended_data)
    end

    def unique_id
      return if uid.blank?

      extended_data["soci"]
    end

    protected

    def uid
      return unless extended_data && extended_data.respond_to?(:key?) && extended_data.has_key?("soci")

      extended_data["soci"].to_i
    end

    def valid_member
      errors.add(:user, I18n.t("somenergia.verifications.not_cas_user")) if uid.blank?
    end
  end
end
