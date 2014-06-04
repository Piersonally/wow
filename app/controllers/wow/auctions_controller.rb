class Wow::AuctionsController < ApplicationController
  before_action :load_auction, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @auctions = auctions
  end

  def in_progress
    @auctions = auctions.where(status: 'in_progress')
    render 'index'
  end

  def sold
    @auctions = auctions.where(status: 'sold')
    render 'index'
  end

  def expired
    @auctions = auctions.where(status: 'expired')
    render 'index'
  end

  def show
    respond_with @auction
  end

  def new
    @auction = Wow::Auction.new
  end

  def edit
    respond_with @auction
  end

  def create
    @auction = Wow::Auction.new(auction_params)
    flash[:notice] = "Auction was successfully created." if @auction.save
    respond_with @auction
  end

  def update
    if @auction.update(auction_params)
      flash[:notice] = "Auction was successfully updated."
    end
    respond_with @auction
  end

  def destroy
    @auction.destroy
    flash[:notice] = "Auction was successfully destroyed."
    respond_with @auction
  end

  private

  def load_auction
    @auction = Wow::Auction.find(params[:id])
  end

  def auction_params
    params.require(:auction).permit(
      :realm_id, :auction_house, :auc, :blizz_item_id, :owner, :owner_realm,
      :buyout, :quantity, :rand, :seed
    )
  end

  def auctions
    Wow::Auction.includes(:realm, :item, :last_snapshot).page(params[:page]).per(20)
  end
end
