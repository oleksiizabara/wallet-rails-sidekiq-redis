# frozen_string_literal: true

module TransactionStateMachine
  class InitState < BaseService
    # @attr_reader params [Hash]:
    # - transaction: [WalletTransaction]

    def call
      state = next_state.constantize if next_state
      state.perform(transaction: transaction) if valid_state?
    rescue StandardError => e
      transaction.update(status: :failed, error_message: "System Error: #{e.message}")
    end

    def valid_state?
      return true if transaction.wallet_from_id.blank?

      wallet_from = Wallet.find(transaction.wallet_from_id)
      result_from = wallet_from.withdraw_money(transaction, sum_for_withdraw)

      if result_from.status == :done
        true
      else
        transaction.update(result_from.as_json)
        false
      end
    end

    private

    def next_state
      'TransactionStateMachine::States::ProcessInitiatorWallet'
    end

    def sum_for_withdraw
      @sum_for_withdraw ||=
        begin
          if transaction.tax_paid_by_the_recipient
            transaction.transfered_money
          else
            transaction.transfered_money + transaction.tax
          end
        end
    end

    def sum_for_receiving
      @sum_for_receiving ||=
        begin
          if transaction.tax_paid_by_the_recipient
            transaction.transfered_money - transaction.tax
          else
            transaction.transfered_money
          end
        end
    end

    def transaction
      @transaction ||= params[:transaction]
    end
  end
end
