class Wow::AuctionsController < ApplicationController
  before_action :load_auction, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @auctions = Wow::Auction.includes(:realm).page(params[:page]).per(20)
  end

  def in_progress
    @auctions = Wow::Auction.includes(:realm)
                            .where(status: 'in_progress')
                            .page(params[:page]).per(20)
    render 'index'
  end

  def completed
    @auctions = Wow::Auction.includes(:realm)
                            .where(status: 'completed')
                            .page(params[:page]).per(20)
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
      :realm_id, :auction_house, :auc, :item, :owner, :owner_realm,
      :buyout, :quantity, :rand, :seed
    )
  end
end
