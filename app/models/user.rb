class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :mobile_number, type: String
  field :password_digest, type: String

  attr_accessor :password

  before_save :hash_password

  def authenticate(unencrypted_password)
    BCrypt::Password.new(password_digest) == unencrypted_password && self
  end

  def email_verification
    user_hash = self.as_json(only: [:id, :email_id])
    puts user_hash
    binding.pry
    TokenHandler.encode(user_hash, expiry: 1.hours.from_now.to_i)
  end


  private

  def hash_password
    if password.present?
      self.password_digest = BCrypt::Password.create(password)
    end
  end
end
