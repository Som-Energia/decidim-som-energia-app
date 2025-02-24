# frozen_string_literal: true

require "rails_helper"

module Decidim::Initiatives
  describe InitiativesController do
    routes { Decidim::Initiatives::Engine.routes }

    let(:organization) { create(:organization) }
    let!(:initiative) { create(:initiative, state: :published, organization:, published_at: "2019-12-31") }
    let!(:created_initiative) { create(:initiative, :created, organization:) }
    let!(:closed_initiative) { create(:initiative, state: :rejected, organization:) }

    before do
      request.env["decidim.current_organization"] = organization
    end

    describe "GET index" do
      # it "Default to closed initiatives after 1/2/2020" do
      #   get :index
      #   expect(controller.helpers.initiatives).not_to include(initiative)
      #   expect(controller.helpers.initiatives).not_to include(created_initiative)
      #   expect(controller.helpers.initiatives).to include(closed_initiative)
      # end

      context "when date is before 1/2/2020" do
        before do
          allow(Time).to receive(:current).and_return(Time.zone.local(2020, 1, 1))
        end

        it "Default to open initiatives" do
          get :index
          expect(controller.helpers.initiatives).to include(initiative)
          expect(controller.helpers.initiatives).not_to include(created_initiative)
          expect(controller.helpers.initiatives).not_to include(closed_initiative)
        end
      end
    end
  end
end
