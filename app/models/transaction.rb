class Transaction < ApplicationRecord
    validates :transaction_type, inclusion: { 
        in: %w(credit debit),
        message: "%{value} must be credit or debit"
    }, presence: true

    validates :source_wallet, absence: true, if: Proc.new { |t| t.transaction_type == "credit" }
    validates :target_wallet, absence: true, if: Proc.new { |t| t.transaction_type == "debit" }
    monetize  :amount_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }

    def self.generate_reference
        count = Transaction.distinct.count(:reference)

        return "TR-#{Date.today.strftime("%Y%m%d")}-#{'%05d' % (count + 1)}"
    end
end
