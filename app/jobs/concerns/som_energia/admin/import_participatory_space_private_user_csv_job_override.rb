# frozen_string_literal: true

module SomEnergia
  module Admin
    module ImportParticipatorySpacePrivateUserCsvJobOverride
      extend ActiveSupport::Concern

      included do
        def perform(email, user_name, privatable_to, current_user)
          return if email.blank? || user_name.blank?

          params = {
            name: user_name,
            email: email.downcase.strip,
            cas_user: true
          }
          private_user_form = Decidim::Admin::ParticipatorySpacePrivateUserForm.from_params(params, privatable_to:)
                                                                               .with_context(
                                                                                 current_user:,
                                                                                 current_particiaptory_space: privatable_to
                                                                               )

          Decidim::Admin::CreateParticipatorySpacePrivateUser.call(private_user_form, privatable_to, via_csv: true)
        end
      end
    end
  end
end
