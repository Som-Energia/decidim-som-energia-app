# frozen_string_literal: true

Decidim::Admin::ParticipatorySpacePrivateUserCsvImportForm.class_eval do
  def validate_csv
    return if file.blank?

    header = CSV.open(file.path, "r", &:first)
    errors.add(:email, "La primera columna ha de contenir emails valids!") unless header.first =~ /^(.+)@(.+)$/
    errors.add(:user_name, "La segona columna ha de noms!") unless header.second
  end
end
