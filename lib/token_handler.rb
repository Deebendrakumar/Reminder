class TokenHandler
    def self.encode(payload, expiry: 15.minutes.from_now.to_i)
        payload[:expiry] = expiry
        JWT.encode(payload, "Deepak", 'HS256')
    end

    def self.decode(token)
        secret_key = "Deepak"
        begin
          decoded_token = JWT.decode(token, secret_key, false, { algorithm: 'HS256' })
          # JWT.decode returns an array where the first element is the payload and the second is the header part of the token
          decoded_token[0].with_indifferent_access # Return the payload
          
        rescue JWT::DecodeError
          # Handle decode errors, e.g., token tampered, wrong signature, etc.
          nil # Or return an appropriate error message/response
        end
    end
end

