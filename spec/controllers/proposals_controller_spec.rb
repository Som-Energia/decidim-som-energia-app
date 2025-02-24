# frozen_string_literal: true

require "rails_helper"

module Decidim::Proposals
  describe ProposalsController do
    routes { Decidim::Proposals::Engine.routes }

    let(:organization) { create(:organization) }
    let(:user) { create(:user, :confirmed, organization:) }
    let(:participatory_process) { create(:participatory_process, :with_steps, slug:, organization:) }
    let(:slug) { "participatory-process" }
    let(:component) do
      create(:component, manifest_name: "proposals", participatory_space: participatory_process)
    end
    let(:enabled_orders) { %w(az za supported_first supported_last) }

    before do
      allow(Decidim::DecidimAwesome).to receive(:possible_additional_proposal_sortings).and_return(enabled_orders)
      request.env["decidim.current_organization"] = organization
      request.env["decidim.current_participatory_space"] = participatory_process
      request.env["decidim.current_component"] = component
    end

    describe "GET index" do
      let(:params) { {} }

      it "renders the index template" do
        get(:index, params:)
        expect(response).to render_template(:index)
      end

      # it "forces no cache headers" do
      #   get(:index, params:)
      #   expect(response.headers["Cache-Control"]).to eq("no-store")
      # end

      it "stores order in session" do
        get :index, params: params.merge(order: "recent")
        expect(session[:order]).to eq("recent")
      end

      it "has default order" do
        get(:index, params:)
        expect(controller.helpers.order).to eq("random")
        expect(controller.helpers.available_orders).to include("az")
        # expect(controller.helpers.available_orders).not_to include("az")
      end

      context "when alternative process" do
        let(:slug) { "SomAG-alternative-process" }

        it "has az order" do
          get(:index, params:)
          expect(controller.helpers.available_orders).to include("az")
          # expect(controller.helpers.order).to eq("az")
        end
      end

      context "when no az order is available" do
        let(:enabled_orders) { %w(za supported_first supported_last) }

        it "has default order" do
          get(:index, params:)
          expect(controller.helpers.order).to eq("random")
          expect(controller.helpers.available_orders).not_to include("az")
        end

        context "when alternative process" do
          let(:slug) { "SomAG-alternative-process" }

          it "has no az order" do
            get(:index, params:)
            expect(controller.helpers.available_orders).not_to include("az")
            expect(controller.helpers.order).to eq("random")
          end
        end
      end
    end

    describe "GET show" do
      let(:proposal) { create(:proposal, component:) }
      let(:params) { { id: proposal.id } }

      it "renders the show template" do
        get(:show, params:)
        expect(response).to render_template(:show)
      end

      it "doesn't force no cache headers" do
        get(:show, params:)
        expect(response.headers["Cache-Control"]).to be_blank
      end

      # it "sets the @report_form variable" do
      #   get(:show, params:)
      #   expect(assigns(:report_form)).to be_a(Decidim::ReportForm)
      # end
    end
  end
end
