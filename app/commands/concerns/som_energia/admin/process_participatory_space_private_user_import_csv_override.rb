# frozen_string_literal: true

module SomEnergia
  module Admin
    module ProcessParticipatorySpacePrivateUserImportCsvOverride
      extend ActiveSupport::Concern

      included do
        def call
          return broadcast(:invalid, @form.errors.full_messages) unless @form.valid?

          @errors = []

          begin
            process_csv
            broadcast(:ok, @errors)
          rescue StandardError => e
            broadcast(:invalid, e.message)
          end
        end

        private

        def process_csv
          CSV.foreach(@form.file.path, encoding: "BOM|UTF-8") do |email, user_name|
            user_name.gsub!(/[<>?%&\^*#@()\[\]=+:;"{}\\|]/, "")

            unless valid_email?(email) && valid_user_name?(user_name)
              @errors << email
              next
            end

            Decidim::Admin::ImportParticipatorySpacePrivateUserCsvJob.perform_later(email, user_name, @private_users_to)
          end
        end

        def valid_email?(email)
          return false if email.blank?

          email.match?(/\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/)
        end

        def valid_user_name?(user_name)
          return false if user_name.blank?

          user_name =~ Decidim::UserBaseEntity::REGEXP_NAME
        end
      end
    end
  end
end
