class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String 
  field :mobile_number, type: String
  field :password_digest, type: String
  validates :name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "is not a valid email" }
  validates :mobile_number, presence: true, numericality: true, length: { is: 10 }
  validates :password_digest, presence: true

  # attr_accessor :password
  embeds_many :event_dates 
  before_save :hash_password

  def authenticate(unencrypted_password)
    BCrypt::Password.new(password_digest) == unencrypted_password && self
  end

  def email_verification
    user_hash = self.as_json(only: [:_id, :email])
    TokenHandler.encode(user_hash, expiry: 1.hours.from_now.to_i)
  end


  private

  def hash_password
    if password_digest.present?
      self.password_digest = BCrypt::Password.create(password_digest)
    end
  end
end