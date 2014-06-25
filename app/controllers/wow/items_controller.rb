module Wow
  class ItemsController < ApplicationController
    def index
      @items = Wow::Item.includes(:auctions)
                        .page(params[:page]).per(15)
    end

    def show
      @item = Wow::Item.includes(:auctions => :snapshots).find params[:id]
    end

    def search
      @items = Wow::Item.search params[:search][:q], misspellings: false
      render :index
    end
  end
end
