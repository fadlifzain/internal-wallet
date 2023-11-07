class Account < ApplicationRecord
    has_secure_password

    validates :name, presence: true
    validates :type, presence: true
    validates :password, presence: true, length: { in: 6..20 }, on: :create
    validates :username, presence: true, length: { in: 4..10 }, uniqueness: true


    def auth(password)
        allowed = authenticate(password)

        raise "Invalid Credentials" unless allowed

        secret = "#{username}-#{password}-#{BCrypt::Password.create(ENV["SECRET"])}"
        self.update(token: Base64.encode64(secret))
    end

    def transfer_to(wallet_id)
    end
end
