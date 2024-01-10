# frozen_string_literal: true

require "rails_helper"

describe "Admin checks consultation results", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }
  let(:consultation) { create(:consultation, :active, organization: organization) }
  let(:question) { create(:question, :multiple, consultation: consultation) }
  let!(:response) { create(:response, question: question) }
  let!(:another_response) { create(:response, question: question) }
  let!(:vote) { create(:vote, response: response, question: question) }
  let!(:another_vote) { create(:vote, response: response, question: question) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_consultations.results_consultation_path(consultation)
  end

  shared_examples "shows table headers" do
    it "shows th" do
      expect(page).to have_selector("th", text: question.title["en"])
      expect(page).to have_selector("th", text: "Total: 2 votes / 2 participants")
    end
  end

  it "shows the table" do
    expect(page).to have_selector("table")
  end

  it_behaves_like "shows table headers"

  context "when consultation is closed" do
    let(:consultation) { create(:consultation, :published_results, :finished, organization: organization) }

    it_behaves_like "shows table headers"

    it "shows simple results" do
      expect(page).to have_selector("td", text: response.title["en"])
      expect(page).to have_selector("td", text: another_response.title["en"])
      expect(page).to have_selector("td", text: "2")
      expect(page).to have_selector("td", text: "0")
    end

    context "and question is grouped" do
      let(:response_group) { create(:response_group, question: question) }
      let!(:response) { create(:response, question: question, response_group: response_group) }
      let!(:another_response) { create(:response, question: question, response_group: response_group) }

      it_behaves_like "shows table headers"

      it "shows results grouped by group" do
        expect(page).to have_selector("th", text: response_group.title["en"])
        expect(page).to have_selector("th", text: "Vots")
        expect(page).to have_selector("td", text: response.title["en"])
        expect(page).to have_selector("td", text: another_response.title["en"])
        expect(page).to have_selector("td", text: "2")
        expect(page).to have_selector("td", text: "0")
      end
    end
  end
end
