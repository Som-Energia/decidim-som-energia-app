# frozen_string_literal: true

require "rails_helper"

describe "Participatory processes", type: :system do
  let!(:organization) { create(:organization) }
  let(:scoped_slug_prefix) { "SomAG" } # same as defined in secrets.yml!!
  let!(:alternative_process) do
    create(
      :participatory_process,
      :active,
      slug: "#{scoped_slug_prefix}-slug",
      scope: first_scope,
      area: first_area,
      organization: organization
    )
  end
  let!(:alternative_process_old) do
    create(
      :participatory_process,
      :past,
      slug: "#{scoped_slug_prefix}-slug2",
      scope: second_scope,
      area: second_area,
      organization: organization
    )
  end
  let!(:normal_process) do
    create(
      :participatory_process,
      :active,
      slug: "normal-slug",
      scope: first_scope,
      area: first_area,
      organization: organization
    )
  end
  let!(:normal_process_old) do
    create(
      :participatory_process,
      :past,
      slug: "normal-slug2",
      scope: second_scope,
      area: second_area,
      organization: organization
    )
  end
  let!(:first_scope) { create(:scope, organization: organization) }
  let!(:second_scope) { create(:scope, organization: organization) }
  let!(:first_area) { create(:area, organization: organization) }
  let!(:second_area) { create(:area, organization: organization) }

  before do
    switch_to_host(organization.host)
  end

  context "when visiting home page" do
    before do
      visit decidim.root_path
    end

    it "shows the original processes menu" do
      within ".main-nav" do
        expect(page).to have_link(text: "Processes", href: "/processes")
      end
    end

    it "shows the extra configured menu" do
      within ".main-nav" do
        expect(page).to have_content("General Assemblies")
        expect(page).to have_link(href: "/general_assemblies")
      end
    end

    context "and navigating to original processes" do
      before do
        within ".main-nav" do
          click_link "Processes"
        end
      end

      it "shows normal processes" do
        within "#processes-grid" do
          expect(page).to have_content(normal_process.title["en"])
          expect(page).not_to have_content(alternative_process.title["en"])
        end
      end

      it "has the default path" do
        expect(page).to have_current_path(decidim_participatory_processes.participatory_processes_path)
      end

      it "filter links points to the normal path" do
        page.all(".order-by__tab").each do |el|
          expect(el[:href]).to match(/#{decidim_participatory_processes.participatory_processes_path}/)
        end
      end

      it "show normal processes when filtering" do
        within ".order-by__tabs" do
          click_link "Past"
        end

        expect(page).to have_content(normal_process_old.title["en"])
        expect(page).not_to have_content(normal_process.title["en"])
        expect(page).not_to have_content(alternative_process.title["en"])
        expect(page).not_to have_content(alternative_process_old.title["en"])
      end
    end

    context "and navigating to alternative processes" do
      before do
        within ".main-nav" do
          click_link "General Assemblies"
        end
      end

      it "shows alternative processes" do
        within "#processes-grid" do
          expect(page).to have_content(alternative_process.title["en"])
          expect(page).not_to have_content(normal_process.title["en"])
        end
      end

      it "has the alternative path" do
        expect(page).to have_current_path(general_assemblies_path)
      end

      context "when filtering by time" do
        before do
          within ".order-by__tabs" do
            click_link "Past"
          end
        end

        it "show alternative processes when filtering" do
          expect(page).to have_content(alternative_process_old.title["en"])
          expect(page).not_to have_content(alternative_process.title["en"])
          expect(page).not_to have_content(normal_process.title["en"])
          expect(page).not_to have_content(normal_process_old.title["en"])
        end

        it "has the alternative path" do
          expect(page).to have_current_path(Regexp.new(general_assemblies_path))
        end
      end

      context "when filtering by scope" do
        before do
          within "#participatory-space-filters" do
            click_link "Select a scope"
          end
          within "#data_picker-modal" do
            click_link translated(first_scope.name)
            click_link "Select"
          end
        end

        it "show alternative processes when filtering" do
          expect(page).to have_content(alternative_process.title["en"])
          expect(page).not_to have_content(alternative_process_old.title["en"])
          expect(page).not_to have_content(normal_process.title["en"])
          expect(page).not_to have_content(normal_process_old.title["en"])
        end

        it "has the alternative path" do
          expect(page).to have_current_path(Regexp.new(general_assemblies_path))
        end
      end

      context "when filtering by area" do
        before do
          within "#participatory-space-filters" do
            select "Select an area"
            select translated(first_area.name)
          end
        end

        it "show alternative processes when filtering" do
          expect(page).to have_content(alternative_process.title["en"])
          expect(page).not_to have_content(alternative_process_old.title["en"])
          expect(page).not_to have_content(normal_process.title["en"])
          expect(page).not_to have_content(normal_process_old.title["en"])
        end

        it "has the alternative path" do
          expect(page).to have_current_path(Regexp.new(general_assemblies_path))
        end
      end
    end
  end

  context "when accessing original processes with an alternative path" do
    before do
      visit "/general_assemblies/#{normal_process.slug}"
    end

    it "redirects to the original path" do
      expect(page).to have_current_path(decidim_participatory_processes.participatory_process_path(normal_process.slug))
    end
  end

  context "when accessing alternative processes with the original path" do
    before do
      visit "/processes/#{alternative_process.slug}"
    end

    it "redirects to the alternative path" do
      expect(page).to have_current_path(general_assembly_path(alternative_process.slug))
    end
  end

  context "when accessing alternative process steps" do
    before do
      visit "/general_assemblies/#{alternative_process.slug}/steps"
    end

    it "shows the alternative process steps" do
      expect(page).to have_content("PROCESS PHASES")
    end
  end

  context "when accessing alternative process widget" do
    before do
      visit "/general_assemblies/#{alternative_process.slug}/embed"
    end

    it "shows the alternative process widget" do
      expect(page).to have_content(alternative_process.title["en"])
      expect(page).to have_content("MORE INFO")
    end
  end
end
