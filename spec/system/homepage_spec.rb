# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", type: :system do
  let(:official_url) { "http://mytesturl.me" }
  let(:organization) { create(:organization, official_url: official_url) }
  let!(:work_groups) { create :assemblies_type, id: 2 }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the home page" do
    within ".main-nav" do
      expect(page).to have_content("Home")
      expect(page).not_to have_content("Management")
      expect(page).not_to have_content("Work groups")
    end
  end

  context "when there is normal assemblies" do
    let!(:assembly) { create(:assembly, :published, organization: organization) }

    it "renders the expected menu" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_content("Home")
        expect(page).to have_content("Management")
        expect(page).not_to have_content("Work groups")
      end
    end
  end

  context "when there is alternative assemblies" do
    let!(:assembly) { create(:assembly, :published, organization: organization) }
    let!(:assembly2) { create(:assembly, :published, assembly_type: work_groups, organization: organization) }

    it "renders the expected menu" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_content("Home")
        expect(page).to have_content("Management")
        expect(page).to have_content("Work groups")
      end
    end
  end
end
