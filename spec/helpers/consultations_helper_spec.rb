# frozen_string_literal: true

require "rails_helper"

module Decidim::Consultations
  describe ConsultationsHelper, type: :helper do
    let(:organization) { create(:organization) }

    before do
      def helper.current_organization; end
      allow(helper).to receive(:current_organization).and_return(organization)
    end

    describe "options_for_state_filter" do
      it "returns options for all available filters" do
        expect(helper.options_for_date_filter).to include(["all", t("consultations.filters.all", scope: "decidim")])
        expect(helper.options_for_date_filter).to include(["active", t("consultations.filters.active", scope: "decidim")])
        expect(helper.options_for_date_filter).to include(["upcoming", t("consultations.filters.upcoming", scope: "decidim")])
      end
    end

    describe "filter_scopes_values" do
      let(:scope) { create(:scope, organization: organization) }
      let(:child_scope) { create(:scope, organization: organization, parent: scope) }
      let!(:grandchild_scope) { create(:scope, organization: organization, parent: child_scope) }

      it "returns a tree of scopes" do
        expect(helper.filter_scopes_values).to be_a(Decidim::CheckBoxesTreeHelper::TreeNode)
      end

      it "returns the root scope" do
        expect(helper.filter_scopes_values.values.first.label).to eq("All")
      end

      it "returns the main scopes" do
        expect(helper.filter_scopes_values.values.second.first.first.label).to eq(scope.name["en"])
      end

      it "returns the child scopes" do
        expect(helper.filter_scopes_values.values.second.first.values.second.first.first.label).to eq(child_scope.name["en"])
      end

      it "returns the grandchild scopes" do
        expect(helper.filter_scopes_values.values.second.first.values.second.first.values.second.first.values.first.label).to eq(grandchild_scope.name["en"])
      end
    end

    describe "scope_children_to_tree" do
      let(:organization) { create(:organization) }
      let(:scope) { create(:scope, organization: organization) }
      let(:child_scope) { create(:scope, organization: organization, parent: scope) }
      let!(:grandchild_scope) { create(:scope, organization: organization, parent: child_scope) }

      it "returns a tree of scopes" do
        expect(helper.scope_children_to_tree(scope)).to be_a(Array)
      end

      it "returns the child scopes" do
        expect(helper.scope_children_to_tree(scope).first.values.first.label).to eq(child_scope.name["en"])
      end

      it "returns the grandchild scopes" do
        expect(helper.scope_children_to_tree(scope).first.values.second.first.values.first.label).to eq(grandchild_scope.name["en"])
      end
    end

    describe "decidim_consultations_question_partial" do
      it "returns the partial path" do
        expect(helper.decidim_consultations_question_partial).to end_with("decidim/consultations/consultations/_question.html.erb")
      end
    end
  end
end
