class Account < ApplicationRecord
    has_secure_password

    validates :name, presence: true
    validates :type, presence: true
    validates :password, presence: true, length: { in: 6..20 }, on: :create
    validates :username, presence: true, length: { in: 4..10 }, uniqueness: true

    after_create :create_wallet

    has_one :wallet

    def auth(password)
        allowed = authenticate(password)

        raise "Invalid Credentials" unless allowed

        secret = "#{'%05d' % rand(0..99999)}-#{username}-#{password}-#{'%05d' % rand(0..99999)}-#{ENV["SECRET"]}"
        self.update(token: Base64.encode64(secret))
    end

    private

    def create_wallet
        self.create_wallet!
    end
end
