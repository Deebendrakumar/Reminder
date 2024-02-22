class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token
    def validate_user
        begin
            binding.pry
            auth_header = request.headers['Authorization']
            raise Exceptions::AuthenticationError if auth_header.nil?
            payload = TokenHandler.decode(auth_header)
            raise Exceptions::AuthenticationError if payload.nil?
            user_id = payload["user_id"]["$oid"]
            @user = User.find_by(id: user_id)
            raise Exceptions::AuthenticationError if @user.nil?
            rescue Exceptions::AuthenticationError
            render json: {message: "Authentication Failed"}, status: :unauthorized
        end
    end
end