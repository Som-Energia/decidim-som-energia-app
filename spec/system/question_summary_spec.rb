# frozen_string_literal: true

require "rails_helper"

describe "Question summary", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }
  let(:consultation) { create(:consultation, :published, organization: organization) }
  let(:question) { create :question, consultation: consultation }

  before do
    switch_to_host(organization.host)
    visit question_summary_path(question)
  end

  describe "path" do
    let(:expected_path) { "/questions/#{question.slug}/summary" }

    it "has expected path" do
      expect(page).to have_current_path(expected_path)
    end
  end

  describe "layout" do
    it "does not show headers" do
      expect(page).to have_no_css(".title-bar")
      expect(page).to have_no_css(".navbar")
    end

    it "does not show footers" do
      expect(page).to have_no_css(".main-footer")
      expect(page).to have_no_css(".mini-footer")
    end

    it "Shows basic question data" do
      expect(page).to have_i18n_content(question.promoter_group)
      expect(page).to have_i18n_content(question.scope.name)
      expect(page).to have_i18n_content(question.participatory_scope)
      expect(page).to have_i18n_content(question.question_context)

      expect(page).not_to have_i18n_content(question.what_is_decided)
    end

    it "Shows technical question data" do
      expect(page).to have_i18n_content(question.promoter_group)
      expect(page).to have_i18n_content(question.scope.name)
      expect(page).to have_i18n_content(question.participatory_scope)
      expect(page).to have_i18n_content(question.question_context)

      click_button("Read more")

      expect(page).to have_i18n_content(question.what_is_decided)
    end
  end
end
