class SplitController < ApplicationController

    # Swagger Documentation
    swagger_controller :split, "Split"

    swagger_api :index do
        summary "Fetches all splits"
        notes "This lists all the splits"
    end

    swagger_api :show do
        summary "Shows one split"
        param :path, :id, :integer, :required, "Split ID"
        notes "This lists details of one split"
        response :not_found
    end

    swagger_api :create do
        summary "Creates a new split"
        param :form, :description, :string, :required, "Description"
        param :form, :split_type, :string, :required, "Split Type"
        param :form, :split_factor, :float, :required, "Split Factor"
        param :form, :total_split_amount, :float, :required, "Total Split Amount"
        param :form, :split_currency_type, :string, :required, "Split Currency Type"
        param :form, :charge_date, :date, :required, "Charge Date"
        param :form, :pay_date, :date, "Pay Date"
        response :not_acceptable
    end

    swagger_api :update do
        summary "Updates an existing split"
        param :path, :id, :integer, :required, "Split ID"
        param :form, :description, :string, :optional, "Description"
        param :form, :split_type, :string, :optional, "Split Type"
        param :form, :split_factor, :float, :optional, "Split Factor"
        param :form, :total_split_amount, :float, :optional, "Total Split Amount"
        param :form, :split_currency_type, :string, :optional, "Split Currency Type"
        param :form, :charge_date, :date, :optional, "Charge Date"
        param :form, :pay_date, :date, :optional, "Pay Date"
        response :not_found
        response :not_acceptable
    end

    swagger_api :destroy do
        summary "Deletes an existing split"
        param :path, :id, :integer, :required, "Split ID"
        response :not_found
    end
  
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