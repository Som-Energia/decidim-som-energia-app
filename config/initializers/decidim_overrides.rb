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
  Decidim::Devise::RegistrationsController.include(SomEnergia::Devise::RegistrationsControllerOverride)
  Decidim::Initiatives::InitiativesController.include(SomEnergia::Initiatives::InitiativesControllerOverride)
  Decidim::Meetings::MeetingsController.include(SomEnergia::Meetings::MeetingsControllerOverride)
  Decidim::Proposals::ProposalsController.include(SomEnergia::Proposals::ProposalsControllerOverride)
  Decidim::Proposals::ProposalsController.include(SomEnergia::Proposals::OrderableOverride)
  Decidim::Assemblies::Admin::ParticipatorySpacePrivateUsersCsvImportsController.include(SomEnergia::Admin::HasPrivateUsersCsvImportOverride)
  Decidim::ParticipatoryProcesses::Admin::ParticipatorySpacePrivateUsersCsvImportsController.include(SomEnergia::Admin::HasPrivateUsersCsvImportOverride)

  # consultations
  Decidim::Consultations::Admin::CreateResponse.include(SomEnergia::Consultations::Admin::CreateResponseOverride)
  Decidim::Consultations::Admin::UpdateQuestionConfiguration.include(SomEnergia::Consultations::Admin::UpdateQuestionConfigurationOverride)
  Decidim::Consultations::Admin::UpdateResponse.include(SomEnergia::Consultations::Admin::UpdateResponseOverride)
  Decidim::Consultations::Admin::QuestionConfigurationForm.include(SomEnergia::Consultations::Admin::QuestionConfigurationFormOverride)
  Decidim::Consultations::Admin::ResponseForm.include(SomEnergia::Consultations::Admin::ResponseFormOverride)
end
