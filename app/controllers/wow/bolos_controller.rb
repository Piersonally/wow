module Wow
  class BolosController < BaseController
    respond_to :html
    before_action :load_bolo, only: [:show, :edit, :update, :destroy]

    def index
      @bolos = current_user.bolos.all
      respond_with @bolos
    end

    def show
      respond_with @bolo
    end

    def new
      @bolo = Bolo.new
      respond_with @bolo
    end

    def edit
      respond_with @bolo
    end

    def create
      @bolo = current_user.bolos.new(bolo_params)
      flash[:notice] = "Alert was successfully created." if @bolo.save
      respond_with @bolo
    end

    def update
      if @bolo.update bolo_params
        flash[:notice] = "Alert was successfully updated."
      end
      respond_with @bolo
    end

    def destroy
      @bolo.destroy
      flash[:notice] = %(Alert for "#{@bolo.item.name}" was successfully destroyed.)
      respond_with @bolo
    end

    private

    def load_bolo
      @bolo = current_user.bolos.find params[:id]
    end

    def bolo_params
      params.require(:bolo).permit :item_id
    end
  end
end
