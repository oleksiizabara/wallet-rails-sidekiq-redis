# frozen_string_literal: true

module Builders
  class TransactionBuilder
    attr_reader :transaction

    def self.build
      builder = new
      yield(builder)
      builder.transaction
    end

    def initialize
      @transaction = WalletTransaction.new
    end

    def build_type(type)
      @transaction.transaction_type = type
    end

    def build_initiator(id)
      @transaction.initiator_id = id
    end

    def build_currency(wallet)
      @transaction.currency = wallet.currency
    end

    def build_money(money, by_recipient)
      @transaction.transfered_money = money
      @transaction.transaction_plan = plan
      @transaction.tax = plan.price
      @transaction.tax_paid_by_the_recipient = by_recipient || false
    end

    def plan
      return @plan if @plan.present?

      t = TransactionPlan.table_name
      money = @transaction.transfered_money
      raise StandardError, 'transfered money must exist' if money.blank?

      @plan = TransactionPlan.find_by(
        "(#{t}.to is null and #{t}.from <= #{money}) or " \
        "(#{money} between #{t}.from and #{t}.to)"
      )
    end
  end
end
