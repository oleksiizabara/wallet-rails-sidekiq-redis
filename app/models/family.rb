# frozen_string_literal: true

class Family < Wallet
  ADMIN_SETTINGS = { day_limit: nil }.freeze
  TransferResult = Struct.new(:status, :error_message)

  has_one :family_wallet_setting

  def new_wallet(params, owner)
    assign_attributes(is_private: true,
                      admin_id: owner.id,
                      identity: params[:wallet_identity],
                      currency_id: params[:currency_id],
                      description: params[:description])
    users << owner if save!
    add_user_settings(ADMIN_SETTINGS.merge(user_id: owner.id))
  end

  def add_user_settings(settings)
    family_settings = FamilyWalletSetting.find_or_initialize_by(family_id: id)
    family_settings.user_settings << settings
    family_settings.save!
  end

  def withdraw_money(transfer, sum_for_transfer)
    limit = available_user_limit(transfer.initiator_id)
    budget = user_budget(transfer.initiator_id)
    withdraw_error = family_error(limit, budget, sum_for_transfer)
    return withdraw_error if withdraw_error.present?

    super
  end

  def family_error(limit, budget, sum)
    return if sum <= budget

    if limit.present? && sum > limit
      TransferResult.new(:failed,
                         'sum of transfer more than your daily limit')
    end
  end

  # balance between user add and get money from this wallet
  def user_budget(initiator_id)
    FamilyWalletBudget.perform(wallet: self, initiator_id: initiator_id)
  end

  def available_user_limit(initiator_id)
    limit = family_wallet_setting.user_settings.detect do |s|
      s['user_id'] == initiator_id
    end['day_limit']
    return if limit.blank?

    limit.to_i - UsedDailyLimit.perform(wallet: self, initiator_id: initiator_id)
  end

  def validate_error(_transfer, sum_for_transfer)
    if balance <= sum_for_transfer
      TransferResult.new(:failed, 'not enough money')
    end
  end
end
