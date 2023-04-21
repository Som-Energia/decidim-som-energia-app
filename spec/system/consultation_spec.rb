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

      it "shows the take part button" do
        expect(page).to have_content("TAKE PART")
      end
    end

    context "when the user is logged in" do
      before do
        switch_to_host(organization.host)
        login_as user, scope: :user
      end

      it "shows the take part button if the user has not voted yet" do
        visit decidim_consultations.consultation_path(consultation)

        expect(page).to have_content("TAKE PART")
      end

      it "shows the already voted button if the user has already voted" do
        question.votes.create(author: user, response: Decidim::Consultations::Response.new)
        visit decidim_consultations.consultation_path(consultation)

        expect(page).to have_content("ALREADY VOTED")
      end
    end
  end

  context "when visiting the question" do
    let!(:question) { create(:question, :published, consultation: consultation) }
    let!(:response1) { create(:response, weight: 2, question: question) }
    let!(:response2) { create(:response, weight: 1, question: question) }

    before do
      switch_to_host(organization.host)
      sign_in user, scope: :user
      visit decidim_consultations.question_path(question)
    end

    it "shows the question title" do
      expect(page).to have_content(question.title["en"])
      click_link "Vote"
      within all(".response-title").first do
        expect(page).to have_content(response2.title["en"])
      end
      within all(".response-title").last do
        expect(page).to have_content(response1.title["en"])
      end
    end

    it "does not show read more" do
      expect(page).not_to have_content("Read more")
      expect(page).not_to have_css(".hide.show-more-panel")
      expect(page).to have_css(".show-more-panel")
    end
  end

  context "when visitin a multiple question" do
    let(:enforce_special_requirements) { true }
    let!(:question) { create(:question, :published, :multiple, enforce_special_requirements: enforce_special_requirements, consultation: consultation) }
    let!(:response1) { create(:response, weight: 2, question: question) }
    let!(:response2) { create(:response, weight: 1, question: question) }

    before do
      switch_to_host(organization.host)
      sign_in user, scope: :user
      visit decidim_consultations.question_path(question)
    end

    it "shows the responses & special requirements" do
      expect(page).to have_content(question.title["en"])
      click_link "Vote"
      expect(page).to have_css('[data-response-weight="1"')
      expect(page).to have_css('[data-response-weight="2"')
      within all(".multiple_votes_form div").first do
        expect(page).to have_content(response2.title["en"])
      end
      within all(".multiple_votes_form div").last do
        expect(page).to have_content(response1.title["en"])
      end
      expect(page).to have_css(".js-group-special-requirements")
      expect(page).to have_css('[data-enforce-special-requirements="true"]')
      expect(page).to have_css(".js-all-groups-not-answered")
      expect(page).to have_css(".js-card-grouped-response")
      expect(page).not_to have_css(".extra__suport-number")
      expect(page).not_to have_content("You can vote up to 3 options.")
    end

    context "when special requirements are not enforced" do
      let(:enforce_special_requirements) { false }

      it "does not show the special requirements" do
        click_link "Vote"
        expect(page).to have_css('[data-enforce-special-requirements="false"]')
        expect(page).not_to have_css(".js-all-groups-not-answered")
        expect(page).to have_css(".extra__suport-number")
        expect(page).to have_content("You can vote up to 3 options.")
      end
    end
  end

  context "when visiting question results" do
    let(:consultation) { create(:consultation, :published_results, organization: organization) }
    let!(:question) { create(:question, :published, :multiple, consultation: consultation) }
    let!(:group) { create(:response_group, question: question) }
    let!(:response1) { create(:response, question: question, response_group: group) }
    let!(:response2) { create(:response, question: question) }

    before do
      switch_to_host(organization.host)
      visit decidim_consultations.question_path(question)
    end

    it "shows the question and response titles" do
      expect(page).to have_content(question.title["en"])
      expect(page).to have_content(response1.title["en"])
      expect(page).to have_content(response2.title["en"])
      expect(page).to have_content(group.title["en"])
    end
  end
end
