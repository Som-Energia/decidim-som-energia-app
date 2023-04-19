# frozen_string_literal: true

module SomEnergia
  module Admin
    module ParticipatorySpacePrivateUserCsvImportFormOverride
      extend ActiveSupport::Concern

      included do
        def validate_csv
          return if file.blank?

          CSV.foreach(file.path) do |email, user_name|
            errors.add(:email, "La primera columna ha de contenir emails vàlids!") unless email&.match?(Devise.email_regexp)
            unless user_name&.match?(Decidim::UserBaseEntity::REGEXP_NAME)
              errors.add(:user_name, "La segona columna ha de contenir noms sense caràcters estranys (parèntesis per exemple)!")
            end
          end
        end
      end
    end
  end
end
