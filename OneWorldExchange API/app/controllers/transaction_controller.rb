class TransactionController < ApplicationController

    # Swagger Documentation
    swagger_controller :transaction, "Transaction"

    swagger_api :index do
        summary "Fetches all transactions"
        notes "This lists all the transactions"
    end

    swagger_api :show do
        summary "Shows one transaction"
        param :path, :id, :integer, :required, "Transaction ID"
        notes "This lists details of one transaction"
        response :not_found
    end

    swagger_api :create do
        summary "Creates a new transaction"
        param :form, :date_charged, :date, :required, "Date Charged"
        param :form, :description, :string, :required, "Description"
        param :form, :currency_type, :string, :required, "Currency Type"
        param :form, :total_charged, :float, :required, "Total Charged"
        param :form, :country, :string, :required, "Country"
        param :form, :expense_type, :string, :required, "Expense Type"
        response :not_acceptable
    end

    swagger_api :update do
        summary "Updates an existing transaction"
        param :path, :id, :integer, :required, "Transaction ID"
        param :form, :date_charged, :date, :optional, "Date Charged"
        param :form, :description, :string, :optional, "Description"
        param :form, :currency_type, :string, :optional, "Currency Type"
        param :form, :total_charged, :float, :optional, "Total Charged"
        param :form, :country, :string, :optional, "Country"
        param :form, :expense_type, :string, :optional, "Expense Type"
        response :not_found
        response :not_acceptable
    end

    swagger_api :destroy do
        summary "Deletes an existing transaction"
        param :path, :id, :integer, :required, "Transaction ID"
        response :not_found
    end
  
    before_action :set_transaction, only: [:show, :update, :destroy]
  
    # GET /transaction
    def index
      @transactions = Transaction.all
  
      render json: @transactions
    end
  
    # GET /transaction/1
    def show
      render json: @transaction
    end
  
    # POST /transaction
    def create
      @transaction = Transaction.new(split_params)
  
      if @transaction.save
        render json: @transaction, status: :created, location: @transaction
      else
        render json: @transaction.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /transaction/1
    def update
      if @transaction.update(transaction_params)
        render json: @transaction
      else
        render json: @transaction.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /transaction/1
    def destroy
      @transaction.destroy
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_transaction
        @transaction = Transaction.find(params[:id])
      end
  
      # Only allow a trusted parameter "white list" through.
      def transaction_params
        params.permit(:date_charged, :description, :currency_type, :total_charged, :country, :expense_type)
      end
  end
