# frozen_string_literal: true

require "rails_helper"

describe "Visit a proposal", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let(:participatory_process) { create :participatory_process, organization: organization }
  let(:proposals_component) { create :component, manifest_name: :proposals, participatory_space: participatory_process }
  let!(:proposal) { create :proposal, component: proposals_component }

  before do
    switch_to_host(organization.host)
    page.visit main_component_path(proposals_component)
    click_link proposal.title["en"]
  end

  it "allows viewing a single proposal" do
    expect(page).to have_content(proposal.title["en"])
    expect(page).to have_content(strip_tags(proposal.body["en"]).strip)
  end
end
