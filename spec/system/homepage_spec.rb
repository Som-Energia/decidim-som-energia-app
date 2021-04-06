# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", type: :system do
  let(:official_url) { "http://mytesturl.lvh.me" }
  let(:organization) { create(:organization, official_url: official_url) }
  let!(:local_groups) { create :assemblies_type, id: 5 }
  let(:slug) { "SomAG-xx" }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the home page" do
    within ".main-nav" do
      expect(page).to have_content("Home")
      expect(page).not_to have_content("Assemblies")
      expect(page).not_to have_content("Local Groups")
    end
  end

  context "when there is normal assemblies" do
    let!(:assembly) { create(:assembly, :published, organization: organization) }

    it "renders the expected menu" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_content("Home")
        expect(page).to have_content("Assemblies")
        expect(page).not_to have_content("Local Groups")
      end
    end
  end

  context "when there is alternative assemblies" do
    let!(:assembly) { create(:assembly, :published, organization: organization) }
    let!(:assembly2) { create(:assembly, :published, assembly_type: local_groups, organization: organization) }

    it "renders the expected menu" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_content("Home")
        expect(page).to have_content("Assemblies")
        expect(page).to have_content("Local Groups")
      end
    end
  end

  context "when there is normal participatory processes" do
    let!(:participatory_process) { create(:participatory_process, :published, organization: organization) }

    it "renders the expected menu" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_content("Home")
        expect(page).to have_content("Processes")
        expect(page).not_to have_content("General Assemblies")
      end
    end
  end

  context "when there is alternative assemblies" do
    let!(:participatory_process) { create(:participatory_process, :published, organization: organization) }
    let!(:participatory_process2) { create(:participatory_process, :published, slug: slug, organization: organization) }

    it "renders the expected menu" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_content("Home")
        expect(page).to have_content("Processes")
        expect(page).to have_content("General Assemblies")
      end
    end
  end
  # it "has matomo tracker" do
  #   expect(page.execute_script("return typeof window._paq")).not_to eq("undefined")
  #   expect(page.execute_script("return typeof window._paq")).to eq("object")
  # end
end
