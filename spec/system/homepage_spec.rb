# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", type: :system do
  let(:official_url) { "http://mytesturl.me" }
  let(:organization) { create(:organization, official_url: official_url) }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the home page" do
    expect(page).to have_content("Home")
  end
end
