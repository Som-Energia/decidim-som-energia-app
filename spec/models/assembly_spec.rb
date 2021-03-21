# frozen_string_literal: true

require "rails_helper"

module Decidim
  describe Assembly do
    let(:type1) { create(:assemblies_type) }
    let(:type2) { create(:assemblies_type) }
    let!(:assembly1) { create(:assembly, slug: "slug1", assembly_type: type1) }
    let!(:assembly2) { create(:assembly, slug: "slug2", assembly_type: type2) }
    let!(:assembly3) { create(:assembly, slug: "slug3", assembly_type: nil) }

    it "assemblies have types assigned" do
      expect(assembly1.decidim_assemblies_type_id).to eq(type1.id)
      expect(assembly2.decidim_assemblies_type_id).to eq(type2.id)
      expect(assembly3.decidim_assemblies_type_id).to eq(nil)
    end

    context "when no scope types" do
      before do
        Assembly.scope_to_types(nil, nil)
      end

      it "has no default scope" do
        expect(Assembly.default_scope).not_to be_present
        expect(Assembly.scope_types).not_to be_present
        expect(Assembly.scope_types_mode).not_to be_present
      end

      it "find all assemblies" do
        assemblies = Assembly.all
        expect(assemblies).to include(assembly1)
        expect(assemblies).to include(assembly2)
        expect(assemblies).to include(assembly3)
      end
    end

    context "when scope types are in :include mode" do
      before do
        Assembly.scope_to_types([type1.id], :include)
      end

      it "has a default scope" do
        expect(Assembly.default_scope).to be_present
        expect(Assembly.scope_types).to eq([type1.id])
        expect(Assembly.scope_types_mode).to eq(:include)
      end

      it "find only included assemblies" do
        assemblies = Assembly.all
        expect(assemblies).to include(assembly1)
        expect(assemblies).not_to include(assembly2)
        expect(assemblies).not_to include(assembly3)
      end
    end

    context "when scope types are in :exclude mode" do
      before do
        Assembly.scope_to_types([type2.id], :exclude)
      end

      it "has a default scope" do
        expect(Assembly.default_scope).to be_present
        expect(Assembly.scope_types).to eq([type2.id])
        expect(Assembly.scope_types_mode).to eq(:exclude)
      end

      it "find only non-included assemblies" do
        assemblies = Assembly.all
        expect(assemblies).to include(assembly1)
        expect(assemblies).not_to include(assembly2)
        expect(assemblies).to include(assembly3)
      end
    end
  end
end
