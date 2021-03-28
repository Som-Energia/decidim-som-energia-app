# frozen_string_literal: true

require "rails_helper"

describe "Participatory processes", type: :system do
  let!(:organization) { create(:organization) }
  let(:scoped_slug_prefix) { "SomAG" } # same as defined in secrets.yml!!
  let!(:alternative_process) { create(:participatory_process, slug: "#{scoped_slug_prefix}-slug", organization: organization) }
  let!(:normal_process) { create(:participatory_process, slug: "normal-slug", organization: organization) }

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
end
