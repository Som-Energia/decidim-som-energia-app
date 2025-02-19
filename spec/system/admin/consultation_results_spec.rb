# frozen_string_literal: true

require "rails_helper"

describe "Consultation_results" do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:consultation) { create(:consultation, :active, organization:) }
  let(:question) { create(:question, :multiple, consultation:) }
  let!(:response) { create(:response, question:) }
  let!(:another_response) { create(:response, question:) }
  let!(:vote) { create(:vote, response:, question:) }
  let!(:another_vote) { create(:vote, response:, question:) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_consultations.results_consultation_path(consultation)
  end

  shared_examples "shows table headers" do
    it "shows th" do
      expect(page).to have_css("th", text: question.title["en"])
      expect(page).to have_css("th", text: "Total: 2 votes / 2 participants")
    end
  end

  it "shows the table" do
    expect(page).to have_table("table")
  end

  it_behaves_like "shows table headers"

  context "when consultation is closed" do
    let(:consultation) { create(:consultation, :published_results, :finished, organization:) }

    it_behaves_like "shows table headers"

    it "shows simple results" do
      expect(page).to have_css("td", text: response.title["en"])
      expect(page).to have_css("td", text: another_response.title["en"])
      expect(page).to have_css("td", text: "2")
      expect(page).to have_css("td", text: "0")
    end

    context "and question is grouped" do
      let(:response_group) { create(:response_group, question:) }
      let!(:response) { create(:response, question:, response_group:) }
      let!(:another_response) { create(:response, question:, response_group:) }

      it_behaves_like "shows table headers"

      it "shows results grouped by group" do
        expect(page).to have_css("th", text: response_group.title["en"])
        expect(page).to have_css("th", text: "Vots")
        expect(page).to have_css("td", text: response.title["en"])
        expect(page).to have_css("td", text: another_response.title["en"])
        expect(page).to have_css("td", text: "2")
        expect(page).to have_css("td", text: "0")
      end
    end
  end
end
