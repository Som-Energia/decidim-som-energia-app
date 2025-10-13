# frozen_string_literal: true

module SomEnergia
  module AuthorizationModalCellOverride
    extend ActiveSupport::Concern

    included do
      alias_method :original_status_fields, :status_fields

      def status_fields(status)
        byebug
        return original_status_fields(status) unless status.handler_name == "cas_member" && status.data[:fields].present?

        status.data[:fields].map do |_field, value|
          content_tag("p", t("decidim.authorization_handlers.cas_member.only_for_#{value}"), class: "callout warning mb-4")
        end
      end
    end
  end
end
