class UsersController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  # before_action :current_user, only: [:show]



  def create
    user = User.create(user_params)
    if user.valid?
      token = generate_token(user)
      render json: { success: true, token: token }.to_json, status: 200
    else
      render json: { success: false, message: "Username Taken" }
    end
  end

  def show
    authorized
    render json: @current_user
  end

  def follow
    authorized
  end

  private

  def current_user
    authenticate_or_request_with_http_token do |jwt_token, options|
      begin
        decoded_token = JWT.decode(jwt_token, Rails.application.credentials.jwt)
      rescue JWT::DecodeError
        return nil
      end

      if decoded_token[0]["user_id"]
        @current_user ||= User.find(decoded_token[0]["user_id"])
      end
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    puts "authorized"
    render json: {message: "Please Log In to Continue"}, status: 401 unless logged_in?
  end

  def user_params
    params.permit(:username, :password)
  end
end
