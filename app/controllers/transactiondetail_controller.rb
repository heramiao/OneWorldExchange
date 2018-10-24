class TransactiondetailController < ApplicationController

    # Swagger Documentation
    swagger_controller :transactiondetail, "Transaction Details"

    swagger_api :index do
        summary "Fetches all transaction details"
        notes "This lists all the transaction details"
    end

    swagger_api :show do
        summary "Shows one transaction's details"
        param :path, :id, :integer, :required, "Transaction Detail ID"
        notes "This lists details of one transaction"
        response :not_found
    end
  
    before_action :set_transaction_details, only: [:show]
  
    # GET /transactiondetail
    def index
      @transactiondetails = TransactionDetail.all
  
      render json: @transactiondetails
    end
  
    # GET /transactiondetail/1
    def show
      render json: @transactiondetail
    end
  
    # POST /children
    def create
        # transaction detail gets created when split gets created
    end
  
    # PATCH/PUT /children/1
    def update
        # transaction detail gets updated when split gets updated
    end
  
    # DELETE /children/1
    def destroy
        # transaction detail gets deleted when split gets deleted 
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_transaction_details
        @transactiondetail = TransactionDetail.find(params[:id])
      end
  end