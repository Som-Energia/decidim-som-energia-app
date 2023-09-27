# frozen_string_literal: true

require "rails_helper"

describe "Admin edits consultation", type: :system do
  let(:organization) { create(:organization, default_locale: "en", available_locales: %w(en ca es)) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }
  let(:consultation) { create(:consultation, organization: organization) }
  let!(:question) { create(:question, consultation: consultation) }
  let!(:response) { create(:response, question: question) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_consultations.edit_question_path(question)
  end

  it "edits the question with special requirements" do
    click_link "Configuració"
    expect(page).to have_selector('input[type="checkbox"]')
    expect(page).to have_content("Aplicar requisits especials (1 vot per pregunta)")
  end

  it "edits a response with weights" do
    visit decidim_admin_consultations.responses_path(question)
    click_link response.title["ca"]
    expect(page).to have_css("#response_weight")
    expect(page).to have_content("Ordre")
  end
end
