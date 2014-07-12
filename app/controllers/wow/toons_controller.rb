module Wow
  class ToonsController < BaseController
    respond_to :html
    before_action :load_toon, only: [:show, :edit, :update, :destroy]

    def index
      @toons = current_user.toons.order(:name)
      respond_with @toons
    end

    def show
      @auctions = auctions
      respond_with @toon
    end

    def new
      @toon = Toon.new
      respond_with @toon
    end

    def edit
      respond_with @toon
    end

    def create
      @toon = current_user.toons.new toon_params
      flash[:notice] = 'Toon was successfully created.' if @toon.save
      respond_with @toon
    end

    def update
      if @toon.update toon_params
        flash[:notice] = 'Toon was successfully updated.'
      end
      respond_with @toon
    end

    def destroy
      @toon.destroy
      flash[:notice] = %(Toon "#{@toon.name}" was successfully destroyed.)
      respond_with @toon
    end

    private

    def load_toon
      @toon = current_user.toons.find params[:id]
    end

    def toon_params
      params.require(:toon).permit :realm_id, :name
    end

    def auctions
      auctions = Wow::Auction.where(owner_realm: @toon.realm.name,
                                    owner: @toon.name)
                             .includes(:realm, :item, :last_snapshot)
                             .page(params[:page]).per(10)
      auctions = auctions.where(status: auctions_status) if auctions_status && auctions_status != 'all'
      auctions
    end

    def auctions_status
      @auctions_status ||= params[:auctions] || 'in_progress'
    end
  end
end
