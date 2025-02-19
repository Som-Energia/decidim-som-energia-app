# frozen_string_literal: true

require "rails_helper"

module Decidim::Consultations
  describe ConsultationsController do
    routes { Decidim::Consultations::Engine.routes }

    let(:organization) { create(:organization) }
    let(:consultation) { create(:consultation, organization:) }

    before do
      request.env["decidim.current_organization"] = organization
    end

    context "when there's a consultation" do
      it "can access it" do
        get :show, params: { slug: consultation.slug }

        expect(subject).to render_template(:show)
        expect(flash[:alert]).to be_blank
        expect(controller.send(:current_participatory_space)).to eq consultation
      end
    end

    context "when there isn't a consultation" do
      it "returns 404" do
        expect { get :show, params: { slug: "invalid-consultation" } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when there are multiple consultations" do
      let(:scope) { create(:scope, organization:) }
      let!(:consultation_one) { create(:consultation, organization:, published_at: 2.days.ago) }
      let!(:consultation_two) { create(:consultation, organization:, highlighted_scope: scope, published_at: 1.day.ago) }

      it "can access the index, ordered by recent" do
        get :index

        expect(subject).to render_template(:index)

        expect(controller.helpers.consultations).to eq([consultation_two, consultation_one])
        expect(controller.send(:default_order)).to eq("recent")
        expect(controller.send(:available_orders)).to eq(%w(recent random))
      end

      context "when filtering by scope" do
        it "can access the index" do
          get :index, params: { filter: { highlighted_scope_ids: [scope.id] } }

          expect(subject).to render_template(:index)

          expect(controller.helpers.consultations).to contain_exactly(consultation_two)
        end
      end
    end
  end
end
