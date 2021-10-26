# frozen_string_literal: true

Decidim::Admin::ImportParticipatorySpacePrivateUserCsvJob.class_eval do
  def perform(email, user_name, privatable_to, current_user)
    return if email.blank? || user_name.blank?

    params = {
      name: user_name,
      email: email.downcase.strip,
      cas_user: true
    }
    private_user_form = Decidim::Admin::ParticipatorySpacePrivateUserForm.from_params(params, privatable_to: privatable_to)
                                                                         .with_context(
                                                                           current_user: current_user,
                                                                           current_particiaptory_space: privatable_to
                                                                         )

    Decidim::Admin::CreateParticipatorySpacePrivateUser.call(private_user_form, current_user, privatable_to, via_csv: true)
  end
end
