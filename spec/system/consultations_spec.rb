# frozen_string_literal: true

require "rails_helper"

describe "Consultations", type: :system do
  let!(:organization) { create(:organization) }
  let!(:consultation_1) do
    create(
      :consultation,
      :published,
      highlighted_scope: grand_child_scope_1,
      organization: organization
    )
  end
  let!(:consultation_2) do
    create(
      :consultation,
      :published,
      highlighted_scope: child_scope_2,
      organization: organization
    )
  end
  let!(:parent_scope_1) { create(:scope, organization: organization) }
  let!(:parent_scope_2) { create(:scope, organization: organization) }
  let!(:child_scope_1) { create(:scope, parent: parent_scope_1) }
  let!(:child_scope_2) { create(:scope, parent: parent_scope_1) }
  let!(:grand_child_scope_1) { create(:scope, parent: child_scope_1) }

  before do
    switch_to_host(organization.host)
    visit decidim_consultations.consultations_path
  end

  describe "filters" do
    describe "scope" do
      context "when filtering by parent scope" do
        before do
          within(".highlighted_scope_ids_check_boxes_tree_filter") do
            uncheck("All")
            check(translated(parent_scope_1.name))
          end
        end

        it "shows expected consultations" do
          within("#consultations") do
            expect(page).to have_i18n_content(consultation_1.title)
            expect(page).to have_i18n_content(consultation_2.title)
          end
        end
      end

      context "when filtering by child scope" do
        before do
          within(".highlighted_scope_ids_check_boxes_tree_filter") do
            find("label", text: translated(parent_scope_1.name)).sibling("button").click
            check(translated(child_scope_2.name))
          end
        end

        it "shows expected consultations" do
          within("#consultations") do
            expect(page).to have_i18n_content(consultation_2.title)
            expect(page).not_to have_i18n_content(consultation_1.title)
          end
        end
      end
    end
  end
end
