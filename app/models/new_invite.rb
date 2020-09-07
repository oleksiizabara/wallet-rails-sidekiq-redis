# frozen_string_literal: true

class NewInvite
  include ActiveModel::Model

  attr_accessor(
    :user_email,
    :wallet_id,
    :message,
    :daily_limit
  )

  def initialize(invite_params = nil, user = nil)
    @invite_params = invite_params
    @user = user
    @invited_user = User.find_by(email: invite_params[:user_email]) if invite_params.present?
  end

  def call
    return unless valid_invite?

    Invite.transaction do
      create_invite
      create_settings if invite_wallet.is_a? Family
    end
  end

  private

  def create_invite
    Invite.create(invite_data)
  end

  def create_settings
    if @invite_params[:daily_limit].blank? || @invite_params[:daily_limit].to_i < 1
      raise StandardError, 'daily limit must exist!'
    end

    user_settings = { day_limit: @invite_params[:daily_limit],
                      user_id: @invited_user.id }
    invite_wallet.add_user_settings(user_settings)
  end

  def invite_data
    {
      from_id: @user.id,
      user_id: @invited_user.id,
      message: @invite_params[:message],
      wallet_id: @invite_params[:wallet_id]
    }
  end

  def invite_wallet
    @invite_wallet ||= Wallet.find(@invite_params[:wallet_id])
  end

  def valid_invite?
    valid? && \
      @invited_user.present? && \
      @user.id != @invited_user.id && \
      invite_wallet.users.exclude?(@invited_user) && \
      @invited_user.invites
                   .where(wallet: invite_wallet)
                   .where(is_declined: nil)
                   .blank? && \
      @invite_params[:message].present?
  end
end
