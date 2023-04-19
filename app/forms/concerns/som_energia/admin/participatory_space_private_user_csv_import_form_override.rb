# frozen_string_literal: true

module SomEnergia
  module Admin
    module ParticipatorySpacePrivateUserCsvImportFormOverride
      extend ActiveSupport::Concern

      included do
        def validate_csv
          return if file.blank?

          CSV.foreach(file.path) do |email, user_name|
            errors.add(:email, "La primera columna ha de contenir emails vàlids!") if email.blank?
            errors.add(:user_name, "La segona columna ha de contenir noms!") if user_name.blank?
          end
        end
      end
    end
  end
end
