class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token

    rescue_from Exception, with: :error

    def validate_user
        auth_header = request.headers['Authorization']
        payload = TokenHandler.decode(auth_header)
        raise Exceptions::AuthenticationError if payload.nil?
        user_id = payload["user_id"]["$oid"]
        @user = User.find_by(id: user_id)
        raise Exceptions::AuthenticationError if @user.nil?
    end

    def error(e)
        case e.class.name
        when Errors::Unprocessable.name
          render_response(e.errors, 422)
        when Exceptions::AuthenticationError.name
          render_response([e.message], 401)
        when ActiveRecord::RecordInvalid.name
          render_response({ message: e }, 500)
        when Errors::Jwt.name
          render_response({ message: e }, 401)
        else
          render_response({ message: e }, 500)
          ErrorNotifier.notify(e, payload: params.merge(email: @current_user&.email, details: response&.body))
          puts e.message
        end
    end
end
