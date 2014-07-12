module Wow
  class RealmsController < BaseController
    respond_to :html
    before_action :load_realm, only: [:show, :edit, :update, :destroy]

    def index
      @realms = Realm.all
      respond_with @realms
    end

    def show
      respond_with @realm
    end

    def new
      @realm = Realm.new
      respond_with @realm
    end

    def edit
      respond_with @realm
    end

    def create
      @realm = Realm.new(realm_params)
      flash[:notice] = 'Realm was successfully created.' if @realm.save
      respond_with @realm
    end

    def update
      if @realm.update realm_params
        flash[:notice] = 'Realm was successfully updated.'
      end
      respond_with @realm
    end

    def destroy
      @realm.destroy
      flash[:notice] = %(Realm "#{@realm.name}" was successfully destroyed.)
      respond_with @realm
    end

    private

    def load_realm
      @realm = Realm.find(params[:id])
    end

    def realm_params
      params.require(:realm).permit :slug, :name, :polling_enabled
    end
  end
end
