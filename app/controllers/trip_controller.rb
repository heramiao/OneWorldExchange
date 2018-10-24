class TripController < ApplicationController
    
    # Swagger documentation
    swagger_controller :trip, "Trip"

    swagger_api :index do
        summary "Fetches all Trips"
        notes "This lists all the trips"
    end

    swagger_api :show do
        summary "Shows one trip"
        param :path, :id, :integer, :required, "Trip ID"
        notes "This details of one trip"
        response :not_found
    end

    before_action :set_trip, only: [:show]
  
    # GET /trip
    def index
      @trips = Trip.all
  
      render json: @trip
    end
  
    # GET /trip/1
    def show
      render json: @trip
    end
  
    # POST /children
    def create
      # trip created once travel group date ends
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_trip
        @trip = Trip.find(params[:id])
      end
  end