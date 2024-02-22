class UsersController < ApplicationController
    
    before_action :validate_user, except: [:signup, :login, :verify_email]
    require 'token_handler'

    def signup
      @user = User.create(user_params)
      render json: {message: 'Created Successfully', token: @user.email_verification}, status: 200
    end

    def verify_email
      binding.pry
      begin
        auth_header = params['token']

        raise Exceptions::AuthenticationError if auth_header.nil?
        payload = TokenHandler.decode(auth_header)
        raise Exceptions::AuthenticationError if payload.nil?
        user_id = payload["user_id"]["$oid"]
        @user = User.find_by(id: user_id)
        raise Exceptions::AuthenticationError if @user.nil?
        render json: {message: "Verified_email"}, status: 200
      rescue Exceptions::AuthenticationError
        render json: {message: "Authentication Failed"}, status: :unauthorized
      end
    end
  
    def login

      user = User.find_by(email: params[:email])
      if user.authenticate(params[:password])
        # byebug
        binding.pry
        token = TokenHandler.encode({ user_id: user.id })
        render json: {message: 'loggedin Successfully', token: token}, status: 200
      else
        render json: { error: 'Invalid credentials' }, status: :BadRequest
      end

    end

    def profile
        @user 
        binding.pry
        render json: {users: @user}, status: 201
    end

    def update
      if @user.update!(name: params[:name])
        render json: {message: 'Success'}
      else
        render json: {message: 'failed'}
      end  
    end

    def delete

    end  

    private
    def user_params
      params.permit(:name, :email, :mobile_number, :password)
    end
end


# ,  sending: UserMailer.send_email(@user).deliver_now