
# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Consultations::Admin::QuestionConfigurationForm.prepend Decidim::Overrides::Consultations::Admin::QuestionConfigurationForm
  Decidim::Consultations::Admin::UpdateQuestionConfiguration.prepend Decidim::Overrides::Consultations::Admin::UpdateQuestionConfiguration
end
