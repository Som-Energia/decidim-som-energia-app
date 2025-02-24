# frozen_string_literal: true

require "rails_helper"

describe "Login page", type: :system do
  let!(:organization) { create :organization }

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("CAS_HOST").and_return("cas.example.org")
    switch_to_host(organization.host)
    visit decidim.new_user_session_path
  end

  it "shows a CAS login button" do
    expect(page).to have_content "Sign in with Som Energia"
    expect(page).to have_content "Sign in for administrators"
    expect(page).not_to have_content "Email"
    expect(page).not_to have_content "Password"

    find(".button-login").click

    expect(page).to have_content "Email"
    expect(page).to have_content "Password"
  end
end
