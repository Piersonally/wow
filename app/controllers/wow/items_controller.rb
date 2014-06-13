module Wow
  class ItemsController < ApplicationController
    def index
      @items = Wow::Item.includes(:auctions).page(params[:page]).per(15)
    end

    def show
      @item = Wow::Item.includes(:auctions).find(params[:id])
    end
  end
end
