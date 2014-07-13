require 'spec_helper'

describe Wow::ToonsController, type: :controller do
  let(:realm) { create :realm }
  let(:user) { create :user }
  let!(:toon) { create :toon, user: user }

  let(:valid_toon_params) {
    { name: "Foo", realm_id: realm.to_param }.with_indifferent_access
  }
  let(:invalid_toon_params) {
    { name: nil }.with_indifferent_access
  }

  context "when logged in" do
    before { sign_in user }

    describe "GET index" do
      it "assigns all toons as @toons" do
        get :index, {}
        expect(assigns :toons).to eq [toon]
      end
    end

    describe "GET show" do
      it "assigns the requested toon as @toon" do
        get :show, id: toon.to_param
        expect(assigns :toon).to eq toon
      end
    end

    describe "GET new" do
      it "assigns a new toon as @toon" do
        get :new, {}
        expect(assigns :toon).to be_a_new Wow::Toon
      end
    end

    describe "GET edit" do
      it "assigns the requested toon as @toon" do
        get :edit, {:id => toon.to_param}
        expect(assigns :toon).to eq toon
      end
    end

    describe "POST create" do
      subject { post :create, toon: toon_params }

      describe "with valid params" do
        let(:toon_params) { valid_toon_params }

        it { expect { subject }.to change(Wow::Toon, :count).by(1) }

        describe "and" do
          before { subject }
          it { expect(assigns :toon).to be_a Wow::Toon }
          it { expect(assigns :toon).to be_persisted }
        end

        it "redirects to the created toon" do
          subject
          expect(response).to redirect_to Wow::Toon.last
        end
      end

      describe "with invalid params" do
        let(:toon_params) { invalid_toon_params }
        before { subject }

        it { expect(assigns :toon).to be_a_new Wow::Toon }
        it { expect(response).to render_template 'new' }
      end
    end

    describe "PATCH update" do
      subject { patch :update, id: toon.id, toon: toon_params }

      describe "with valid params" do
        let(:toon_params) { valid_toon_params }

        it "updates the requested toon" do
          allow(controller).to receive_message_chain(:current_user, :toons, :find).and_return(toon)
          expect(toon).to receive(:update).with(toon_params)
          subject
        end

        describe "and" do
          before { subject }

          it { expect(assigns :toon).to eq toon }
          it { expect(response).to redirect_to toon }
        end
      end

      describe "with invalid params" do
        let(:toon_params) { invalid_toon_params }
        before { subject }

        it { expect(assigns :toon).to eq toon }
        it { expect(response).to render_template 'edit' }
      end
    end

    describe "DELETE destroy" do
      subject { delete :destroy, id: toon.to_param }

      it "destroys the requested toon" do
        expect { subject }.to change(Wow::Toon, :count).by(-1)
      end

      it "redirects to the toons list" do
        subject
        expect(response).to redirect_to wow_toons_url
      end
    end
  end
end

