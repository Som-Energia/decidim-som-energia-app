# frozen_string_literal: true

Decidim::Admin::ProcessParticipatorySpacePrivateUserImportCsv.class_eval do
  def call
    return broadcast(:invalid, @form.errors.values.flatten) unless @form.valid?

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
    CSV.foreach(@form.file.path) do |email, user_name|
      user_name.gsub!(/[<>?%&\^*#@\(\)\[\]\=\+\:\;\"\{\}\\\|]/, "")

      unless valid_email?(email) && valid_user_name?(user_name)
        @errors << email
        next
      end

      Decidim::Admin::ImportParticipatorySpacePrivateUserCsvJob.perform_later(email, user_name, @private_users_to, @current_user)
    end
  end

  def valid_email?(email)
    return false if email.blank?

    email =~ /^(.+)@(.+)$/
  end

  def valid_user_name?(user_name)
    return false if user_name.blank?

    user_name =~ Decidim::UserBaseEntity::REGEXP_NAME
  end
end
