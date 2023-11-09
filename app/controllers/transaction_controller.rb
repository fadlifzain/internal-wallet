class TransactionController < ApplicationController
    def transfer
        target_wallet = Wallet.find_by(wallet_id: params[:target_wallet]).with(:account)

        return render(json: { message: "Invalid Wallet ID" }, status: :bad_request) unless target_wallet

        reference = Transaction.generate_reference
        amount = Money.from_amount params["amount"]
        note = "Tranfer from #{@@user.wallet.wallet_id} to #{target_wallet}"

        ActiveRecord::Base.transaction do
            begin
                @@user.wallet.withdraw(amount)
                Transaction.create(
                    transaction_type: "debit",
                    source_wallet: @@user.wallet.wallet_id,
                    amount: amount,
                    reference: reference,
                    transaction_note: note
                )

                target_wallet.deposit(amount)
                Transaction.create(
                    transaction_type: "credit",
                    target_wallet: target_wallet.wallet_id,
                    amount: amount,
                    reference: reference,
                    transaction_note: note
                )
            rescue => e
                Rails.logger.info "[TF][#{reference}] #{e.message}"

                message = @@user.wallet.errors.any? ? @@user.wallet.errors.first.full_message : nil
                return render(json: { message: message ? message : "Transfer error" }, status: :bad_request)
            end
        end

        render json: { 
            message: "Transfer success",
            data: {
                name: target_wallet.account.name,
                amount: params[:amount],
                reference: reference
            }
        }, status: :ok
    end

    def withdraw
        reference = Transaction.generate_reference
        amount = Money.from_amount params["amount"]
        note = "Withdraw from #{@@user.wallet.wallet_id}"

        ActiveRecord::Base.transaction do
            begin
                @@user.wallet.withdraw(amount)
                Transaction.create(
                    transaction_type: "debit",
                    source_wallet: @@user.wallet.wallet_id,
                    amount: amount,
                    reference: reference,
                    transaction_note: note
                )
            rescue => e
                Rails.logger.info "[WD][#{reference}] #{e.message}"

                message = @@user.wallet.errors.any? ? @@user.wallet.errors.first.full_message : nil
                return render(json: { message: message ? message : "Withdraw error" }, status: :bad_request)
            end
        end

        render json: { 
            message: "Withdraw success",
            data: {
                balance: @@user.wallet.balance.amount,
                amount: params[:amount],
                reference: reference
            }
        }, status: :ok
    end

    def deposit
        reference = Transaction.generate_reference
        amount = Money.from_amount params["amount"]
        note = "Deposit to #{@@user.wallet.wallet_id}"

        ActiveRecord::Base.transaction do
            begin
                @@user.wallet.deposit(amount)
                Transaction.create(
                    transaction_type: "credit",
                    target_wallet: @@user.wallet.wallet_id,
                    amount: amount,
                    reference: reference,
                    transaction_note: note
                )
            rescue => e
                Rails.logger.info "[DP][#{reference}] #{e.message}"

                message = @@user.wallet.errors.any? ? @@user.wallet.errors.first.full_message : nil
                return render(json: { message: message ? message : "Deposit error" }, status: :bad_request)
            end
        end

        render json: { 
            message: "Deposit success",
            data: {
                balance: @@user.wallet.balance.amount,
                amount: params[:amount],
                reference: reference
            }
        }, status: :ok
    end

    def index
        offset = (params[:offset] || "0").to_i
        limit = (params[:limit] || "10").to_i

        transactions = Transaction.where(source_wallet: @@user.wallet.wallet_id)
                            .or(Transaction.where(target_wallet: @@user.wallet.wallet_id))
                            .offset(offset)
                            .limit(limit)
                            .order(created_at: :desc)

        render json: {
            data: transactions,
            offset: offset,
            limit: limit
        }, status: :ok
    end

    private

    def transfer_params
        params.permit(:target_wallet, :amount)
    end

    def account_params
        params.permit(:amount)
    end
end
