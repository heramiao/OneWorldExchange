class TripController < ApplicationController
    
  
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