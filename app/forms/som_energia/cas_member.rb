# frozen_string_literal: true

require "digest"

module SomEnergia
  class CasMember < Decidim::AuthorizationHandler
    attribute :extended_data
    attribute :role, String
    validate :valid_member

    def form_attributes
      attributes.except("id", "user", "extended_data", "role", "tos_agreement").keys
    end

    def extended_data
      super || user.try(:extended_data) || {}
    end

    def metadata
      super.merge(username: extended_data["username"],
                  member_type:,
                  soci:)
    end

    def unique_id
      return if uid.blank?

      uid
    end

    def to_partial_path
      "som_energia/cas_member/form"
    end

    protected

    def soci
      return unless extended_data && extended_data.respond_to?(:has_key?)

      extended_data["soci"].to_i
    end

    def member_type
      soci.zero? ? (role.presence || "user") : "member"
    end

    def uid
      return unless extended_data && extended_data.respond_to?(:has_key?)

      return role.present? && "forced-#{user.id}" if extended_data["username"].blank?

      extended_data["username"]
    end

    def valid_member
      errors.add(:user, I18n.t("somenergia.verifications.not_cas_user")) if uid.blank?
    end
  end
end
