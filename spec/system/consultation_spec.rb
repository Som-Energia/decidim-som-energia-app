# frozen_string_literal: true

require "rails_helper"

describe "Consultation", type: :system do
  let!(:organization) { create(:organization) }
  let!(:consultation) { create(:consultation, :published, organization: organization) }
  let!(:user) { create(:user, :confirmed, organization: organization) }

  # This test ensures we are rendering the default partial when viewing a consultation (not the summary).
  context "when showing the button that links to the question" do
    let!(:question) { create(:question, :published, consultation: consultation, scope: consultation.highlighted_scope) }

    context "when the user is not logged in" do
      before do
        switch_to_host(organization.host)
        visit decidim_consultations.consultation_path(consultation)
      end

      it "shows the `take part` button" do
        expect(page).to have_content("TAKE PART")
      end
    end

    context "when the user is logged in" do
      before do
        switch_to_host(organization.host)
        login_as user, scope: :user
      end

      it "shows the `take part` button if the user has not voted yet" do
        visit decidim_consultations.consultation_path(consultation)

        expect(page).to have_content("TAKE PART")
      end

      it "shows the `already voted` button if the user has already voted" do
        question.votes.create(author: user, response: Decidim::Consultations::Response.new)
        visit decidim_consultations.consultation_path(consultation)

        expect(page).to have_content("ALREADY VOTED")
      end
    end
  end
end
