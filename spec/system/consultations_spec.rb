# frozen_string_literal: true

require "rails_helper"

describe "Consultations", type: :system do
  let!(:organization) { create(:organization) }
  let!(:consultation_one) do
    create(
      :consultation,
      :published,
      highlighted_scope: grand_child_scope_one,
      organization: organization
    )
  end
  let!(:consultation_two) do
    create(
      :consultation,
      :published,
      highlighted_scope: child_scope_two,
      organization: organization
    )
  end
  let!(:parent_scope_one) { create(:scope, organization: organization) }
  let!(:parent_scope_two) { create(:scope, organization: organization) }
  let!(:child_scope_one) { create(:scope, parent: parent_scope_one) }
  let!(:child_scope_two) { create(:scope, parent: parent_scope_one) }
  let!(:grand_child_scope_one) { create(:scope, parent: child_scope_one) }

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
            check(translated(parent_scope_one.name))
          end
        end

        it "shows expected consultations" do
          within("#consultations") do
            expect(page).to have_i18n_content(consultation_one.title)
            expect(page).to have_i18n_content(consultation_two.title)
          end
        end
      end

      context "when filtering by child scope" do
        before do
          within(".highlighted_scope_ids_check_boxes_tree_filter") do
            find("label", text: translated(parent_scope_one.name)).sibling("button").click
            check(translated(child_scope_two.name))
          end
        end

        it "shows expected consultations" do
          within("#consultations") do
            expect(page).to have_i18n_content(consultation_two.title)
            expect(page).not_to have_i18n_content(consultation_one.title)
          end
        end
      end
    end
  end
end
