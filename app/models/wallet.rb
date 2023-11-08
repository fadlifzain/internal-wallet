class Wallet < ApplicationRecord

    validates :wallet_id, presence: true
    
    monetize  :balance_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }

    before_validation :generate_wallet_id

    belongs_to :account

    private

    def generate_wallet_id
        #username dash leading zero with rand number
        return unless self.new_record?

        self.wallet_id = "#{self.account.username}-#{'%03d' % rand(0..999)}"
    end
end
