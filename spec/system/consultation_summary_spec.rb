# frozen_string_literal: true

require "rails_helper"

describe "Consultation summary", type: :system do
  let!(:organization) { create(:organization) }
  let!(:consultation) { create(:consultation, :published, organization: organization) }
  let!(:question) { create(:question, consultation: consultation) }

  before do
    switch_to_host(organization.host)
  end

  shared_examples "path" do
    it "has expected path" do
      expect(page).to have_current_path(expected_path)
    end
  end

  shared_examples "layout" do
    it "does not show headers" do
      expect(page).to have_no_css(".title-bar")
      expect(page).to have_no_css(".navbar")
    end

    it "does not show footers" do
      expect(page).to have_no_css(".main-footer")
      expect(page).to have_no_css(".mini-footer")
    end
  end

  context "when visiting a consultation summary" do
    before do
      visit consultation_summary_path(consultation)
    end

    let(:expected_path) { consultation_summary_path(consultation) }

    include_examples "path"
    include_examples "layout"

    it "Shows link to question summary" do
      expect(page).to have_link(translated(question.title), href: question_summary_path(question))
    end

    it "Shows the basic consultation data" do
      expect(page).to have_i18n_content(consultation.title)
      expect(page).to have_i18n_content(consultation.subtitle)
      expect(page).to have_i18n_content(consultation.description)
    end

    context "when visiting a question summary" do
      before do
        click_link(translated(question.title))
      end

      let(:expected_path) { question_summary_path(question) }

      include_examples "path"
      include_examples "layout"

      it "shows link to consultation summary" do
        expect(page).to have_link(translated(consultation.title), href: consultation_summary_path(consultation))
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
end
