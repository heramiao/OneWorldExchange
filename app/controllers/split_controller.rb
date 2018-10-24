class SplitController < ApplicationController
  
    before_action :set_split, only: [:show, :update, :destroy]
  
    # GET /split
    def index
      @splits = Split.all
  
      render json: @splits
    end
  
    # GET /split/1
    def show
      render json: @split
    end
  
    # POST /split
    def create
      @split = Split.new(split_params)
  
      if @split.save
        render json: @split, status: :created, location: @split
      else
        render json: @split.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /split/1
    def update
      if @split.update(split_params)
        render json: @split
      else
        render json: @split.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /split/1
    def destroy
      @split.destroy
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_split
        @split = Split.find(params[:id])
      end
  
      # Only allow a trusted parameter "white list" through.
      def split_params
        params.permit(:description, :split_type, :split_factor, :total_split_amount, :split_currency_type, :charge_date, :pay_date)
      end
  end