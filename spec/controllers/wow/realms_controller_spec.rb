require 'spec_helper'

describe Wow::RealmsController do
  let!(:realm) { create :realm }

  let(:valid_realm_params) {
    { name: "Foo", slug: "foo" }.with_indifferent_access
  }
  let(:invalid_realm_params) {
    { name: nil }.with_indifferent_access
  }

  describe "GET index" do
    it "assigns all realms as @realms" do
      get :index, {}
      expect(assigns :realms).to eq [realm]
    end
  end

  describe "GET show" do
    it "assigns the requested realm as @realm" do
      get :show, id: realm.to_param
      expect(assigns :realm).to eq realm
    end
  end

  describe "GET new" do
    it "assigns a new realm as @realm" do
      get :new, {}
      expect(assigns :realm).to be_a_new Wow::Realm
    end
  end

  describe "GET edit" do
    it "assigns the requested realm as @realm" do
      get :edit, {:id => realm.to_param}
      expect(assigns :realm).to eq realm
    end
  end

  describe "POST create" do
    subject { post :create, realm: realm_params }

    describe "with valid params" do
      let(:realm_params) { valid_realm_params }

      it { expect { subject }.to change(Wow::Realm, :count).by(1) }

      describe "and" do
        before { subject }
        it { expect(assigns :realm).to be_a Wow::Realm }
        it { expect(assigns :realm).to be_persisted }
      end

      it "redirects to the created realm" do
        subject
        expect(response).to redirect_to Wow::Realm.last
      end
    end

    describe "with invalid params" do
      let(:realm_params) { invalid_realm_params }
      before { subject }

      it { expect(assigns :realm).to be_a_new Wow::Realm }
      it { expect(response).to render_template 'new' }
    end
  end

  describe "PATCH update" do
    subject { patch :update, id: realm.id, realm: realm_params }

    describe "with valid params" do
      let(:realm_params) { valid_realm_params }

      it "updates the requested realm" do
        allow(Wow::Realm).to receive(:find).and_return(realm)
        expect(realm).to receive(:update).with(realm_params)
        subject
      end

      describe "and" do
        before { subject }

        it { expect(assigns :realm).to eq realm }
        it { expect(response).to redirect_to realm }
      end
    end

    describe "with invalid params" do
      let(:realm_params) { invalid_realm_params }
      before { subject }

      it { expect(assigns :realm).to eq realm }
      it { expect(response).to render_template 'edit' }
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, id: realm.to_param }

    it "destroys the requested realm" do
      expect { subject }.to change(Wow::Realm, :count).by(-1)
    end

    it "redirects to the realms list" do
      subject
      expect(response).to redirect_to wow_realms_url
    end
  end
end

