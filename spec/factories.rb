# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/proposals/test/factories"
require "decidim/decidim_awesome/test/factories"
require "decidim/consultations/test/factories"
require "decidim/initiatives/test/factories"

shared_examples "a participatory space with extra menu" do |prefix|
  let!(:linked_space) { create(:participatory_process, organization:) }

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("#{prefix}#{participatory_space.slug.upcase}", "").and_return("Decidim::ParticipatoryProcess/#{linked_space.slug}")
    visit visit_path
  end

  it "shows the extra menu" do
    within "#process-nav-content" do
      expect(page).to have_link(href: "/processes/#{linked_space.slug}")
    end
  end

  context "when visiting another space" do
    let!(:another_space) { create(:participatory_process, organization:) }
    let(:visit_path) { decidim_participatory_processes.participatory_process_path(another_space.slug) }

    it "does not show the extra menu" do
      within "#process-nav-content" do
        expect(page).to have_no_link(href: "/processes/#{linked_space.slug}")
      end
    end
  end
end
