# frozen_string_literal: true

class UsedDailyLimit < BaseQuery
  # @attr_reader params [Hash]:
  # - wallet: [Family]
  # -initiator_id: [Integer]

  def call
    by_initiator
    by_from_wallet
    by_time_period
    select
    sum
  end

  private

  def by_initiator
    @transactions = transactions.where(initiator_id: params[:initiator_id])
  end

  def by_from_wallet
    @transactions = @transactions.where("#{tablename}.wallet_from_id = #{wallet.id}")
  end

  def by_time_period
    start = Date.today.beginning_of_day
    finish = Date.today.end_of_day
    @transactions = @transactions.where("#{tablename}.updated_at between ? and ?", start, finish)
  end

  def select
    @transactions = @transactions.select(
      "#{tablename}.transfered_money as money"
    )
  end

  def sum
    @transactions.as_json.map do |op|
      op['money']
    end.sum || 0
  end

  def transactions
    @transactions = wallet.wallet_transactions.done
  end

  def wallet
    params[:wallet]
  end

  def tablename
    WalletTransaction.table_name
  end
end
