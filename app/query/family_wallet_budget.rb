# frozen_string_literal: true

class FamilyWalletBudget < BaseQuery
  # @attr_reader params [Hash]:
  # - wallet: [Family]
  # -initiator_id: [Integer]

  def call
    by_initiator
    select
    sum
  end

  private

  def by_initiator
    @transactions = transactions.where(initiator_id: params[:initiator_id])
  end

  def select
    @transactions = @transactions.select(:id,
                                         "#{tablename}.wallet_to_id = #{wallet.id} as is_from_user",
                                         "#{tablename}.transfered_money as money")
  end

  def sum
    @transactions.as_json.map do |op|
      op['is_from_user'] ? op['money'] : -op['money']
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
