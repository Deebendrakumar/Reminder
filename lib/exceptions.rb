module Exceptions
    class AuthenticationError < StandardError; end
end

module Errors
    class Unprocessable < StandardError; end
    class Jwt < StandardError; end
end

