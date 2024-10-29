# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", type: :system do
  let(:organization) { create(:organization) }
  let!(:user) { create(:user, :confirmed, organization: organization) }
  let!(:assembly) { create(:assembly, organization: organization) }
  let(:membership) { assembly.slug }
  let(:menu) do
    {
      organization.host.to_sym => [
        {
          key: "somenergia.menu.team_et",
          url: "/assemblies/#{assembly.slug}",
          position: 10,
          if_membership_in: membership
        }
      ]
    }
  end

  before do
    allow(Rails.application.secrets).to receive(:menu).and_return(menu)
    switch_to_host(organization.host)
  end

  shared_examples "do not show menu" do
    it "item is not visible" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).not_to have_link(href: "/assemblies/#{assembly.slug}")
      end
    end
  end

  shared_examples "shows menu" do
    it "item is visible" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_link(href: "/assemblies/#{assembly.slug}")
      end
    end
  end

  context "when user is not logged" do
    it_behaves_like "do not show menu"
  end

  context "when user is logged" do
    before do
      login_as user, scope: :user
    end

    it_behaves_like "do not show menu"

    context "and membership is not required" do
      let(:membership) { nil }

      it_behaves_like "shows menu"

      context "and assembly do not exist" do
        let(:membership) { "nonsense" }

        it_behaves_like "do not show menu"
      end
    end

    context "and user belongs to the assembly" do
      let!(:assembly_private_user) { create(:assembly_private_user, user: user, privatable_to: assembly) }

      it_behaves_like "shows menu"
    end
  end

  it_behaves_like "a participatory space with extra menu", "EXTRA_ASSEMBLY_MENU_" do
    let(:participatory_space) { assembly }
    let(:visit_path) { decidim_assemblies.assembly_path(assembly.slug) }
  end
end
