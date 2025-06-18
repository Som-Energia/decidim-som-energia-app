# frozen_string_literal: true

require "rails_helper"

describe "Homepage", perform_enqueued: true do
  let(:organization) { create(:organization) }
  let!(:content_block) { create(:content_block, organization:, manifest_name: :hero) }

  before do
    switch_to_host(organization.host)
  end

  it "renders the home page" do
    visit decidim.root_path
    expect(page).to have_content("Welcome")

    within "#main-bar" do
      expect(page).to have_css(".main-header__language-container")
      within ".main-bar" do
        click_on "English"
        click_on "Català"
      end
    end
    expect(page).to have_content("Benvinguda")
  end
end
