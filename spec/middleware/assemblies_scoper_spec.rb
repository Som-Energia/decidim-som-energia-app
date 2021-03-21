# frozen_string_literal: true

require "rails_helper"

describe AssembliesScoper do
  let(:app) { ->(env) { [200, env, "app"] } }
  let(:env) { Rack::MockRequest.env_for("https://#{host}/#{path}?foo=bar", "decidim.current_organization" => organization) }
  let(:host) { "city.domain.org" }
  let(:middleware) { described_class.new(app) }
  let(:path) { "some_path" }
  let!(:organization) { create(:organization, host: host) }
  let!(:organization2) { create(:organization, host: "another.host.org") }
  let(:alternative_type) { create :assemblies_type }
  let(:normal_type) { create :assemblies_type }
  let!(:external_assembly) { create(:assembly, slug: "external-slug1", organization: organization2) }
  let!(:external_assembly2) { create(:assembly, slug: "slug2", organization: organization2) }
  let!(:alternative_assembly) { create(:assembly, slug: "slug1", assembly_type: alternative_type, organization: organization) }
  let!(:assembly1) { create(:assembly, slug: "slug2", assembly_type: normal_type, organization: organization) }
  let!(:assembly2) { create(:assembly, slug: "slug3", assembly_type: nil, organization: organization) }

  let(:route) { "alternative_assemblies" }
  let(:types) { [alternative_type.id] }
  let(:alternative_assembly_types) do
    [
      {
        key: route,
        assembly_type_ids: types
      }
    ]
  end

  before do
    Decidim::Assembly.scope_to_types(nil, nil)
    allow(AssembliesScoper).to receive(:alternative_assembly_types).and_return(alternative_assembly_types)
  end

  shared_examples "same environment" do
    it "do not modify the environment" do
      code, new_env = middleware.call(env)

      expect(new_env).to eq(env)
      expect(code).to eq(200)
    end

    it "has current organization in env" do
      _code, new_env = middleware.call(env)

      expect(new_env["decidim.current_organization"]).to eq(env["decidim.current_organization"])
    end
  end

  shared_examples "untampered assembly model" do
    it "assembly model is not tampered" do
      # ensure model is always reset after calling the middleware
      Decidim::Assembly.scope_to_types([123], :include)
      middleware.call(env)

      expect(Decidim::Assembly.scope_types).not_to be_present
      expect(Decidim::Assembly.scope_types_mode).not_to be_present
    end
  end

  shared_examples "unaffected routes" do
    context "when path is the home" do
      let(:path) { "" }

      it_behaves_like "same environment"
      it_behaves_like "untampered assembly model"
    end

    context "when path any other" do
      let(:path) { "another_path" }

      it_behaves_like "same environment"
      it_behaves_like "untampered assembly model"
    end
  end

  shared_examples "exclude types" do
    it_behaves_like "same environment"

    it "assembly model is tampered with exclude types" do
      middleware.call(env)

      expect(Decidim::Assembly.scope_types).to eq(types)
      expect(Decidim::Assembly.scope_types_mode).to eq(:exclude)
    end

    it "assembly queries only non-specified types" do
      middleware.call(env)

      expect(Decidim::Assembly.find_by(id: alternative_assembly.id)).not_to be_present
      expect(Decidim::Assembly.find_by(id: assembly1.id)).to eq(assembly1)
      expect(Decidim::Assembly.find_by(id: assembly2.id)).to eq(assembly2)
    end
  end

  shared_examples "include types" do
    it_behaves_like "same environment"

    it "assembly model is tampered with include types" do
      middleware.call(env)

      expect(Decidim::Assembly.scope_types).to eq(types)
      expect(Decidim::Assembly.scope_types_mode).to eq(:include)
    end

    it "assembly queries only specified types" do
      middleware.call(env)

      expect(Decidim::Assembly.find_by(id: alternative_assembly.id)).to eq(alternative_assembly)
      expect(Decidim::Assembly.find_by(id: assembly1.id)).not_to be_present
      expect(Decidim::Assembly.find_by(id: assembly2.id)).not_to be_present
    end
  end

  context "when no alternative types" do
    let(:alternative_assembly_types) { [] }

    it_behaves_like "unaffected routes"
  end

  context "when alternative types" do
    it_behaves_like "unaffected routes"

    context "and assemblies index" do
      let(:path) { "assemblies" }

      it_behaves_like "exclude types"
    end

    context "and assemblies alternative index" do
      let(:path) { route }

      it_behaves_like "include types"
    end

    context "and correct assembly" do
      let(:path) { "assemblies/#{assembly1.slug}" }

      it_behaves_like "exclude types"

      it "do not redirect" do
        code, new_env = middleware.call(env)

        expect(new_env["Location"]).not_to be_present
        expect(code).to eq(200)
      end
    end

    context "and incorrect assembly" do
      let(:path) { "assemblies/#{alternative_assembly.slug}" }

      it_behaves_like "untampered assembly model"

      it "redirects" do
        code, new_env = middleware.call(env)

        expect(new_env["Location"]).to eq("/#{route}/#{alternative_assembly.slug}")
        expect(code).to eq(301)
      end
    end

    context "and correct alternative assembly" do
      let(:path) { "#{route}/#{alternative_assembly.slug}" }

      it_behaves_like "include types"

      it "do not redirect" do
        code, new_env = middleware.call(env)

        expect(new_env["Location"]).not_to be_present
        expect(code).to eq(200)
      end
    end

    context "and incorrect alternative assembly" do
      let(:path) { "#{route}/#{assembly2.slug}" }

      it_behaves_like "untampered assembly model"

      it "redirects" do
        code, new_env = middleware.call(env)

        expect(new_env["Location"]).to eq("/assemblies/#{assembly2.slug}")
        expect(code).to eq(301)
      end
    end

    context "when assembly from other organization" do
      let(:path) { "assemblies/#{external_assembly.slug}" }

      it_behaves_like "same environment"
      it_behaves_like "untampered assembly model"

      it "assembly is not found" do
        _code, _new_env = middleware.call(env)

        expect(middleware.send(:assembly)).not_to be_present
      end
    end
  end
end
