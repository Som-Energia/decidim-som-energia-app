# frozen_string_literal: true

require "rails_helper"

describe "Visit assemblies", type: :system do
  let(:organization) { create :organization }
  let!(:local_groups) { create :assemblies_type, id: 5 }
  let!(:type2) { create :assemblies_type, id: 2 }
  let!(:alternative_assembly) do
    create(
      :assembly,
      slug: "slug1",
      scope: scope_1,
      area: area_1,
      assembly_type: local_groups,
      organization: organization
    )
  end
  let!(:assembly) do
    create(
      :assembly,
      slug: "slug2",
      scope: scope_2,
      area: area_2,
      assembly_type: nil,
      organization: organization
    )
  end
  let!(:assembly2) do
    create(
      :assembly,
      slug: "slug3",
      scope: scope_2,
      area: area_2,
      assembly_type: type2,
      organization: organization
    )
  end
  let!(:scope_1) { create(:scope, organization: organization) }
  let!(:scope_2) { create(:scope, organization: organization) }
  let!(:area_1) { create(:area, organization: organization) }
  let!(:area_2) { create(:area, organization: organization) }

  before do
    switch_to_host(organization.host)
  end

  context "when visiting home page" do
    before do
      visit decidim.root_path
    end

    it "shows the original assembly menu" do
      within ".main-nav" do
        expect(page).to have_content("Assemblies")
        expect(page).to have_link(href: "/assemblies")
      end
    end

    it "shows the extra configured menu" do
      within ".main-nav" do
        expect(page).to have_content("Local Groups")
        expect(page).to have_link(href: "/local_groups")
      end
    end

    context "and navigating to original assemblies" do
      before do
        within ".main-nav" do
          click_link "Assemblies"
        end
      end

      it "shows assemblies without excluded types" do
        within "#parent-assemblies" do
          expect(page).not_to have_content(alternative_assembly.title["en"])
          expect(page).to have_content(assembly2.title["en"])
          expect(page).to have_content(assembly.title["en"])
        end
      end

      it "has the assemblies path" do
        expect(page).to have_current_path decidim_assemblies.assemblies_path
      end
    end

    context "and navigating to alternative assemblies" do
      before do
        within ".main-nav" do
          click_link "Local Groups"
        end
      end

      it "shows assemblies without excluded types" do
        within "#parent-assemblies" do
          expect(page).to have_content(alternative_assembly.title["en"])
          expect(page).not_to have_content(assembly2.title["en"])
          expect(page).not_to have_content(assembly.title["en"])
        end
      end

      it "has the alternative path" do
        expect(page).to have_current_path local_groups_path
      end

      context "when filtering by scope" do
        before do
          within "#participatory-space-filters" do
            click_link "Select a scope"
          end
          within "#data_picker-modal" do
            click_link translated(scope_1.name)
            click_link "Select"
          end
        end

        it "show alternative processes when filtering" do
          within "#parent-assemblies" do
            expect(page).to have_content(alternative_assembly.title["en"])
            expect(page).not_to have_content(assembly2.title["en"])
            expect(page).not_to have_content(assembly.title["en"])
          end
        end

        it "has the alternative path" do
          expect(page).to have_current_path(Regexp.new(local_groups_path))
        end
      end

      context "when filtering by area" do
        before do
          within "#participatory-space-filters" do
            select "Select an area"
            select translated(area_1.name)
          end
        end

        it "show alternative processes when filtering" do
          within "#parent-assemblies" do
            expect(page).to have_content(alternative_assembly.title["en"])
            expect(page).not_to have_content(assembly2.title["en"])
            expect(page).not_to have_content(assembly.title["en"])
          end
        end

        it "has the alternative path" do
          expect(page).to have_current_path(Regexp.new(local_groups_path))
        end
      end
    end
  end

  context "when accessing original assemblies with an alternative path" do
    before do
      visit "/local_groups/#{assembly2.slug}"
    end

    it "redirects to the original path" do
      expect(page).to have_current_path decidim_assemblies.assembly_path(assembly2.slug)
    end
  end

  context "when accessing alternative assemblies with the original path" do
    before do
      visit "/assemblies/#{alternative_assembly.slug}"
    end

    it "redirects to the alternative path" do
      expect(page).to have_current_path local_group_path(alternative_assembly.slug)
    end
  end

  context "when accessing non typed assemblies with the alternative path" do
    before do
      visit "/local_groups/#{assembly.slug}"
    end

    it "redirects to the original path" do
      expect(page).to have_current_path decidim_assemblies.assembly_path(assembly.slug)
    end
  end
end
