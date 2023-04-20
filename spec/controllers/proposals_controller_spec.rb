# frozen_string_literal: true

require "rails_helper"

module Decidim::Proposals
  describe ProposalsController, type: :controller do
    routes { Decidim::Proposals::Engine.routes }

    let(:organization) { create(:organization) }
    let(:user) { create(:user, :confirmed, organization: organization) }
    let(:participatory_process) { create(:participatory_process, :with_steps, slug: slug, organization: organization) }
    let(:slug) { "participatory-process" }

    let(:component) do
      create(:component, manifest_name: "proposals", participatory_space: participatory_process)
    end

    before do
      request.env["decidim.current_organization"] = organization
      request.env["decidim.current_participatory_space"] = participatory_process
      request.env["decidim.current_component"] = component
    end

    describe "GET index" do
      let(:params) { {} }

      it "renders the index template" do
        get :index, params: params
        expect(response).to render_template(:index)
      end

      it "forces no cache headers" do
        get :index, params: params
        expect(response.headers["Cache-Control"]).to eq("no-cache, no-store")
      end

      it "stores order in session" do
        get :index, params: params.merge(order: "recent")
        expect(session[:order]).to eq("recent")
      end

      it "has default order" do
        get :index, params: params
        expect(controller.helpers.available_orders).not_to include("alphabetic")
      end

      context "when alternative process" do
        let(:slug) { "SomAG-alternative-process" }

        it "has alphabetic order" do
          get :index, params: params
          expect(controller.helpers.available_orders).to include("alphabetic")
        end
      end
    end

    describe "GET show" do
      let(:proposal) { create(:proposal, component: component) }
      let(:params) { { id: proposal.id } }

      it "renders the show template" do
        get :show, params: params
        expect(response).to render_template(:show)
      end

      it "doesn't force no cache headers" do
        get :show, params: params
        expect(response.headers["Cache-Control"]).to be_blank
      end

      it "sets the @report_form variable" do
        get :show, params: params
        expect(assigns(:report_form)).to be_a(Decidim::ReportForm)
      end
    end
  end
end
