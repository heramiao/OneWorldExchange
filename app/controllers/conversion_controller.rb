class ConversioController < ApplicationController

    # Swagger Documentation
    swagger_controller :conversion, "Conversion"

    swagger_api :show do
        summary "Shows one conversion"
        param :path, :id, :integer, :required, "Conversion ID"
        notes "This lists details of one conversion"
        response :not_found
    end
  
    before_action :set_conversion, only: [:show]
  
    # GET /conversion/1
    def show
      render json: @conversion
    end
  
    # POST /children
    def create
      # conversion created when split created
    end
  
    # DELETE /children/1
    def destroy
      # conversion deleted when split deleted
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_conversion
        @conversion = Conversion.find(params[:id])
      end
  end