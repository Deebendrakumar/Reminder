class UsersController < ApplicationController

    before_action :validate_user, except: [:signup, :login, :verify_email, :password_reset_link, :reset_password]

    before_action :decode, only: [:verify_email, :reset_password]

    def signup
      @user = User.create!(user_params)
      render json: {message: 'Created Successfully', token: @user.email_verification}, status: 200
    end

    def verify_email
      begin
        raise 'Invalid token' if !@payload["process"] == 'email_verification'
        binding.pry
        user_from_token
        render json: {message: "Email Verificaton successful"}, status: 200
      rescue Exceptions::AuthenticationError
        render json: {message: "Authentication Failed"}, status: :unauthorized
      end
    end

    def login
      user = User.find_by(email: params[:email])
      if user.authenticate(params[:password_digest])
        token = TokenHandler.encode({ user_id: user.id })
        binding.pry
        render json: {message: 'loggedin Successfully', token: token}, status: :ok
      else
        render json: { error: 'Invalid credentials' }, status: :bad_request
      end
    end

    def password_reset_link
      email = params[:email]
      user = User.find_by(email: email)
      token = user.reset_password_email
      render json: {token: token}
    end

    def reset_password
      begin
        raise 'Invalid token' if !@payload["process"] == 'reset_password'
        user_from_token
        @user.password_digest=params[:password_digest]
        @user.save
        render json: {message: "Password Reset successful"}, status: 200
      rescue Exceptions::AuthenticationError
        render json: {message: "Authentication Failed"}, status: :unauthorized
      end
    end

    def profile
        @user
        render json: {name: @user.name, email: @user.email, mobile_number: @user.mobile_number}, status: :ok
    end

    def update
      if @user.update!(name: params[:name], mobile_number: params[:mobile_number])
        render json: {message: 'Success'}
      else
        render json: {message: 'failed'}
      end
    end

    def delete
      @user.destroy
      render json: {message: 'Deletion Successful'}, status: :ok
    end

    private
    def user_params
      params.permit(:name, :email, :mobile_number, :password_digest)
    end

    def decode
      auth_header = params['token']
      @payload = TokenHandler.decode(auth_header)
      raise Exceptions::AuthenticationError if @payload.nil?
    end

    def user_from_token
      user_id = @payload["_id"]["$oid"]
      @user = User.find_by(id: user_id)
      raise Exceptions::AuthenticationError if @user.nil?
    end
end