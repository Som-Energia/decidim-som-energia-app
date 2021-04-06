# frozen_string_literal: true

require "rails_helper"

module Decidim
  describe ParticipatoryProcess do
    let!(:organization) { create(:organization) }
    let(:scoped_slug_prefix) { "alternative" }
    let!(:alternative_process) { create(:participatory_process, slug: "#{scoped_slug_prefix}-slug", organization: organization) }
    let!(:normal_process) { create(:participatory_process, slug: "normal-slug", organization: organization) }

    context "when no scope types" do
      before do
        ParticipatoryProcess.scope_from_slug_prefixes(nil, nil)
      end

      it "has no default scope" do
        expect(ParticipatoryProcess.default_scope).not_to be_present
        expect(ParticipatoryProcess.scoped_slug_prefixes).not_to be_present
        expect(ParticipatoryProcess.scoped_slug_prefixes_mode).not_to be_present
      end

      it "find all processes" do
        processes = ParticipatoryProcess.all
        expect(processes).to include(alternative_process)
        expect(processes).to include(normal_process)
      end
    end

    context "when scope types are in :include mode" do
      before do
        ParticipatoryProcess.scope_from_slug_prefixes([scoped_slug_prefix], :include)
      end

      it "has a default scope" do
        expect(ParticipatoryProcess.default_scope).to be_present
        expect(ParticipatoryProcess.scoped_slug_prefixes).to eq([scoped_slug_prefix])
        expect(ParticipatoryProcess.scoped_slug_prefixes_mode).to eq(:include)
      end

      it "find only included processes" do
        processes = ParticipatoryProcess.all
        expect(processes).to include(alternative_process)
        expect(processes).not_to include(normal_process)
      end
    end

    context "when scope types are in :exclude mode" do
      before do
        ParticipatoryProcess.scope_from_slug_prefixes([scoped_slug_prefix], :exclude)
      end

      it "has a default scope" do
        expect(ParticipatoryProcess.default_scope).to be_present
        expect(ParticipatoryProcess.scoped_slug_prefixes).to eq([scoped_slug_prefix])
        expect(ParticipatoryProcess.scoped_slug_prefixes_mode).to eq(:exclude)
      end

      it "find only non-included processes" do
        processes = ParticipatoryProcess.all
        expect(processes).not_to include(alternative_process)
        expect(processes).to include(normal_process)
      end
    end
  end
end
