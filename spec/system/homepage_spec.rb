# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", type: :system do
  let(:official_url) { "http://mytesturl.lvh.me" }
  let(:organization) { create(:organization, official_url: official_url) }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the home page" do
    expect(page).to have_content("Home")
  end

  # it "has matomo tracker" do
  #   expect(page.execute_script("return typeof window._paq")).not_to eq("undefined")
  #   expect(page.execute_script("return typeof window._paq")).to eq("object")
  # end
end
