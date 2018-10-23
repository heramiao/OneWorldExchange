class TravelgroupController < ApplicationController

    before_action :set_travel_group, only: [:show, :update, :destroy]
  
    # GET /travelgroup
    def index
      @travelgroups = TravelGroup.all
      render json: @travelgroups
    end
  
    # GET /travelgroup/1
    def show
      render json: @travelgroup
    end
  
    # POST /travelgroup
    def create
      @travelgroup = TravelGroup.new(travel_group_params)
  
      if @travelgroup.save
        render json: @travelgroup, status: :created, location: @travelgroup
      else
        render json: @travelgroup.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /travelgroup/1
    def update
      if @travelgroup.update(travel_group_params)
        render json: @travelgroup
      else
        render json: @travelgroup.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /travelgroup/1
    def destroy
      @travelgroup.destroy
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_travel_group
        @travel_group = TravelGroup.find(params[:id])
      end
  
      # Only allow a trusted parameter "white list" through.
      def travel_group_params
        params.permit(:trip_name, :start_date, :end_date)
      end
  end