class UserController < ApplicationController

  # Swagger Documentation
  swagger_controller :user, "User Accounts"

  swagger_api :index do
    summary "Fetches all users"
    notes "This lists all the users"
  end

  swagger_api :show do
    summary "Shows one user"
    param :path, :id, :integer, :required, "User ID"
    notes "This lists details of one user"
    response :not_found
  end

  swagger_api :create do
    summary "Creates a new user"
    param :form, :first_name, :string, :required, "First Name"
    param :form, :last_name, :string, :required, "Last Name"
    param :form, :email, :string, :required, "Email"
    param :form, :phone, :string, :required, "Phone"
    param :form, :password, :string, :required, "Password"
    param :form, :password_confirmation, :string, :required, "Password Confirmation"
    param :form, :base_currency, :string, :required, "Base Currency"
    response :not_acceptable
  end

  swagger_api :update do
    summary "Updates an existing user"
    param :path, :id, :integer, :required, "User ID"
    param :form, :first_name, :string, :optional, "First Name"
    param :form, :last_name, :string, :optional, "Last Name"
    param :form, :email, :string, :optional, "Email"
    param :form, :phone, :string, :optional, "Phone"
    param :form, :password, :string, :optional, "Password"
    param :form, :password_confirmation, :string, :optional, "Password Confirmation"
    param :form, :base_currency, :string, :optional, "Base Currency"
    response :not_found
    response :not_acceptable
  end

  swagger_api :destroy do
    summary "Deletes an existing user"
    param :path, :id, :integer, :required, "User ID"
    response :not_found
  end

  before_action :set_user, only: [:show, :update, :destroy]

  # GET /user
  def index
    @users = User.all
    render json: @users
  end

  # GET /user/1
  def show
    render json: @user
  end

  # POST /user
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:first_name, :last_name, :email, :phone, :password, :password_confirmation, :base_currency)
    end
end