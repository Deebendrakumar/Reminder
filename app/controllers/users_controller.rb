class UsersController < ApplicationController

    before_action :validate_user, except: [:signup, :login, :verify_email, :reset_password]

    before_action :decode, only: [:verify_email, :reset_password]

    def signup
      @user = User.create!(user_params)
      render json: {message: 'Created Successfully', token: @user.email_verification}, status: 200
    end

    def verify_email
      begin
        raise 'Invalid token' if !@payload["process"] == 'email_verification'
        user_from_token
        render json: {message: "Email Verified"}, status: 200
      rescue Exceptions::AuthenticationError
        render json: {message: "Authentication Failed"}, status: :unauthorized
      end
    end

    def login
      user = User.find_by(email: params[:email])
      if user.authenticate(params[:password_digest])
        token = TokenHandler.encode({ user_id: user.id })
        render json: {message: 'loggedin Successfully', token: token}, status: :ok
      else
        render json: {message: 'Invalid credentials' }, status: :bad_request
      end
    end

    def password_reset_link
      binding.pry
      email = params[:email]
      user = User.find_by(email: email)
      user.reset_password_email
    end

    def reset_password
      begin
        binding.pry
        raise 'Invalid token' if !@payload["process"] == 'reset_password'
        user_from_token
        @user.password_digest=params[:password_digest]
        @user.save
        # reset password from params
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

    end

    private
    def user_params
      params.permit(:name, :email, :mobile_number, :password_digest)
    end

    def decode
      binding.pry
      auth_header = params['token']
      @payload = TokenHandler.decode(auth_header)
      raise Exceptions::AuthenticationError if @payload.nil?
    end

    def user_from_token
      binding.pry
      user_id = @payload["_id"]["$oid"]
      @user = User.find_by(id: user_id)
      raise Exceptions::AuthenticationError if @user.nil?
    end
end


# ,  sending: UserMailer.send_email(@user).deliver_now
