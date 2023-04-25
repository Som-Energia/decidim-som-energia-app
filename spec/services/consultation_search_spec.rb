# frozen_string_literal: true

require "rails_helper"

module Decidim::Consultations
  # Refers to the filter in consultations list view
  describe ConsultationSearch do
    subject do
      described_class.new(
        search_text: search_text,
        state: state,
        highlighted_scope_ids: highlighted_scope_ids,
        organization: organization
      ).results
    end

    let(:organization) { create :organization }
    let(:search_text) { nil }
    let(:state) { "all" }
    let(:highlighted_scope_ids) { [] }

    describe "when the filter includes search_text" do
      let(:search_text) { "dog" }

      it "returns the consultations containing the search in the title, subtitle or the description" do
        create_list(:consultation, 3, :published, organization: organization)
        create(:consultation, :published, title: { 'en': "A dog in the title" }, organization: organization)
        create(:consultation, :published, subtitle: { 'en': "A dog in the subtitle" }, organization: organization)
        create(:consultation, :published, description: { 'en': "There is a dog in the office" }, organization: organization)

        expect(subject.size).to eq(3)
      end
    end

    describe "when the filter includes state" do
      let!(:active_consultations) do
        create_list(:consultation, 3, :published, :active, organization: organization)
      end

      let!(:upcoming_consultations) do
        create_list(:consultation, 3, :published, :upcoming, organization: organization)
      end

      let!(:finished_consultations) do
        create_list(:consultation, 3, :published, :finished, organization: organization)
      end

      context "when filtering active consultations" do
        let(:state) { "active" }

        it "returns only active initiatives" do
          expect(subject.size).to eq(3)
          expect(subject).to match_array(active_consultations)
        end
      end

      context "when filtering upcoming consultations" do
        let(:state) { "upcoming" }

        it "returns only upcoming consultations" do
          expect(subject.size).to eq(3)
          expect(subject).to match_array(upcoming_consultations)
        end
      end

      context "when filtering finished consultations" do
        let(:state) { "finished" }

        it "returns only finished consultations" do
          expect(subject.size).to eq(3)
          expect(subject).to match_array(finished_consultations)
        end
      end

      context "when filtering all consultations" do
        let(:state) { "all" }

        it "Returns all consultations" do
          expect(subject.size).to eq(9)
          expect(subject).to include(*active_consultations)
          expect(subject).to include(*upcoming_consultations)
          expect(subject).to include(*finished_consultations)
        end
      end
    end

    describe "when the filter includes highlighted_scope_ids" do
      let(:scope) { create(:scope, organization: organization) }
      let(:scope2) { create(:scope, organization: organization) }
      let(:scope3) { create(:scope, organization: organization) }
      let(:scope4) { create(:scope, organization: organization) }
      let(:scope5) { create(:scope, organization: organization) }

      let!(:consultation1) { create(:consultation, :published, organization: organization, highlighted_scope: scope) }
      let!(:consultation2) { create(:consultation, :published, organization: organization, highlighted_scope: scope2) }
      let!(:consultation3) { create(:consultation, :published, organization: organization, highlighted_scope: scope3) }
      let!(:consultation4) { create(:consultation, :published, organization: organization, highlighted_scope: scope4) }
      let!(:consultation5) { create(:consultation, :published, organization: organization, highlighted_scope: scope5) }

      let(:highlighted_scope_ids) { [scope.id, scope2.id, scope3.id] }

      it "returns the consultations that belong to the highlighted scopes" do
        expect(subject.size).to eq(3)
        expect(subject).to match_array([consultation1, consultation2, consultation3])
      end
    end
  end
end
