# frozen_string_literal: true

module TransactionStateMachine
  module States
    class ProcessInitiatorWallet < InitState
      def next_state
        'TransactionStateMachine::States::ProcessReceivingWallet'
      end

      def valid_state?
        wallet_to = Wallet.find(transaction.wallet_to_id)

        result_to = wallet_to.receiving_money(transaction, sum_for_receiving)

        if result_to.status == :done
          transaction.update(status: :done)
          true
        else
          transaction.update(result_to.as_json)
          false
        end
      end
    end
  end
end
