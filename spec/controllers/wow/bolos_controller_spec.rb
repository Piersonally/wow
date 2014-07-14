require 'spec_helper'

describe Wow::BolosController, type: :controller do
  let(:item) { create :item }
  let(:user) { create :user }
  let!(:bolo) { create :bolo, watcher: user }

  let(:valid_bolo_params) {
    { item_id: item.to_param }.with_indifferent_access
  }
  let(:invalid_bolo_params) {
    { item_id: nil }.with_indifferent_access
  }

  context "when logged in" do
    before { sign_in user }

    describe "GET index" do
      it "assigns all bolos as @bolos" do
        get :index, {}
        expect(assigns :bolos).to eq [bolo]
      end
    end

    describe "GET show" do
      it "assigns the requested bolo as @bolo" do
        get :show, id: bolo.to_param
        expect(assigns :bolo).to eq bolo
      end
    end

    describe "GET new" do
      it "assigns a new bolo as @bolo" do
        get :new, {}
        expect(assigns :bolo).to be_a_new Wow::Bolo
      end
    end

    describe "GET edit" do
      it "assigns the requested bolo as @bolo" do
        get :edit, {:id => bolo.to_param}
        expect(assigns :bolo).to eq bolo
      end
    end

    describe "POST create" do
      subject { post :create, bolo: bolo_params }

      describe "with valid params" do
        let(:bolo_params) { valid_bolo_params }

        it { expect { subject }.to change(Wow::Bolo, :count).by(1) }

        describe "and" do
          before { subject }
          it { expect(assigns :bolo).to be_a Wow::Bolo }
          it { expect(assigns :bolo).to be_persisted }
        end

        it "redirects to the created bolo" do
          subject
          expect(response).to redirect_to Wow::Bolo.last
        end
      end

      describe "with invalid params" do
        let(:bolo_params) { invalid_bolo_params }
        before { subject }

        it { expect(assigns :bolo).to be_a_new Wow::Bolo }
        it { expect(response).to render_template 'new' }
      end
    end

    describe "PATCH update" do
      subject { patch :update, id: bolo.id, bolo: bolo_params }

      describe "with valid params" do
        let(:bolo_params) { valid_bolo_params }

        it "updates the requested bolo" do
          allow(controller).to receive_message_chain(:current_user, :bolos, :find).and_return(bolo)
          expect(bolo).to receive(:update).with(bolo_params)
          subject
        end

        describe "and" do
          before { subject }

          it { expect(assigns :bolo).to eq bolo }
          it { expect(response).to redirect_to bolo }
        end
      end

      describe "with invalid params" do
        let(:bolo_params) { invalid_bolo_params }
        before { subject }

        it { expect(assigns :bolo).to eq bolo }
        it { expect(response).to render_template 'edit' }
      end
    end

    describe "DELETE destroy" do
      subject { delete :destroy, id: bolo.to_param }

      it "destroys the requested bolo" do
        expect { subject }.to change(Wow::Bolo, :count).by(-1)
      end

      it "redirects to the bolos list" do
        subject
        expect(response).to redirect_to wow_bolos_url
      end
    end
  end
end
