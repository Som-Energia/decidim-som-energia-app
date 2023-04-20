# frozen_string_literal: true

Rails.application.config.to_prepare do
  # participatory spaces private users
  Decidim::Admin::ParticipatorySpacePrivateUserForm.include(SomEnergia::Admin::ParticipatorySpacePrivateUserFormOverride)
  Decidim::Admin::ParticipatorySpacePrivateUserCsvImportForm.include(SomEnergia::Admin::ParticipatorySpacePrivateUserCsvImportFormOverride)
  Decidim::Admin::ProcessParticipatorySpacePrivateUserImportCsv.include(SomEnergia::Admin::ProcessParticipatorySpacePrivateUserImportCsvOverride)
  Decidim::Admin::CreateParticipatorySpacePrivateUser.include(SomEnergia::Admin::CreateParticipatorySpacePrivateUserOverride)
  Decidim::Admin::ImportParticipatorySpacePrivateUserCsvJob.include(SomEnergia::Admin::ImportParticipatorySpacePrivateUserCsvJobOverride)
  Decidim::Consultations::ConsultationSearch.include(SomEnergia::Consultations::ConsultationSearchOverride)
  Decidim::Consultations::ConsultationsController.include(SomEnergia::Consultations::ConsultationsControllerOverride)
  Decidim::Consultations::ConsultationsHelper.include(SomEnergia::Consultations::ConsultationsHelperOverride)
  Decidim::Devise::InvitationsController.include(SomEnergia::Devise::InvitationsControllerOverride)

  # consultations
  Decidim::Consultations::Admin::QuestionConfigurationForm.prepend Decidim::Overrides::Consultations::Admin::QuestionConfigurationForm
  Decidim::Consultations::Admin::UpdateQuestionConfiguration.prepend Decidim::Overrides::Consultations::Admin::UpdateQuestionConfiguration
  Decidim::Consultations::Admin::ResponseForm.prepend Decidim::Overrides::Consultations::Admin::ResponseForm
  Decidim::Consultations::Admin::CreateResponse.prepend Decidim::Overrides::Consultations::Admin::CreateResponse
  Decidim::Consultations::Admin::UpdateResponse.prepend Decidim::Overrides::Consultations::Admin::UpdateResponse
end
