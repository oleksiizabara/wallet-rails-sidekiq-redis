# frozen_string_literal: true

module TransactionStateMachine
  module States
    class ProcessReceivingWallet < InitState
      def next_state; end

      def valid_state?; end
    end
  end
end
