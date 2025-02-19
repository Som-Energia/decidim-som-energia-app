# frozen_string_literal: true

require "rails_helper"

describe "Admin_edits_consultation" do
  let(:organization) { create(:organization, default_locale: "en", available_locales: %w(en ca es)) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:consultation) { create(:consultation, organization:) }
  let!(:question) { create(:question, consultation:) }
  let!(:response) { create(:response, question:) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_consultations.edit_question_path(question)
  end

  it "edits the question with special requirements" do
    click_on "Configuration"
    expect(page).to have_field('input[type="checkbox"]')
    expect(page).to have_content("Apply special requirements (1 vote per question)")
  end

  it "edits a response with weights" do
    visit decidim_admin_consultations.responses_path(question)
    click_on response.title["en"]
    expect(page).to have_css("#response_weight")
    expect(page).to have_content("Order")
  end
end
