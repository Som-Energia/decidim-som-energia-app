# frozen_string_literal: true

module Decidim
  module Initiatives
    # Mailer for initiatives engine.
    class InitiativesMailer < Decidim::ApplicationMailer
      include Decidim::TranslatableAttributes
      include Decidim::SanitizeHelper

      add_template_helper Decidim::TranslatableAttributes
      add_template_helper Decidim::SanitizeHelper

      # Notifies initiative creation
      def notify_creation(initiative)
        return if initiative.author.email.blank?

        @username = initiative.author.name
        @initiative = initiative
        @organization = initiative.organization

        with_user(initiative.author) do
          @subject = I18n.t(
            "decidim.initiatives.initiatives_mailer.creation_subject",
            title: translated_attribute(initiative.title)
          )

          mail(to: "#{initiative.author.name} <#{initiative.author.email}>", subject: @subject)
        end
      end

      # Notify changes in state
      def notify_state_change(initiative, user)
        return if user.email.blank?

        @username = initiative.author.name
        @organization = initiative.organization
        state = initiative.state
        title = translated_attribute(initiative.title)

        with_user(user) do
          @subject = I18n.t("decidim.initiatives.initiatives_mailer.status_change_for", title: title)

          @body = case state
                  when "published"
                    I18n.t("decidim.initiatives.initiatives_mailer.published", title: title)
                  when "discarded"
                    I18n.t("decidim.initiatives.initiatives_mailer.discarted", title: title)
                  else
                    I18n.t("decidim.initiatives.initiatives_mailer.status_change_body_for",
                           title: title,
                           state: I18n.t(state, scope: "decidim.initiatives.admin_states"))
                  end

          @link = initiative_url(initiative, host: @organization.host)

          mail(to: "#{user.name} <#{user.email}>", subject: @subject)
        end
      end

      # Notify an initiative requesting technical validation
      def notify_validating_request(initiative, user)
        return if user.email.blank?

        @username = initiative.author.name
        @organization = initiative.organization
        @link = decidim_admin_initiatives.edit_initiative_url(initiative, host: @organization.host)

        with_user(user) do
          @subject = I18n.t(
            "decidim.initiatives.initiatives_mailer.technical_validation_for",
            title: translated_attribute(initiative.title)
          )
          @body = I18n.t(
            "decidim.initiatives.initiatives_mailer.technical_validation_body_for",
            title: translated_attribute(initiative.title)
          )

          mail(to: "#{user.name} <#{user.email}>", subject: @subject)
        end
      end

      # Notify progress to all initiative subscribers.
      def notify_progress(_, _); end
    end
  end
end
