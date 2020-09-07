# frozen_string_literal: true

class Invite < ApplicationRecord
  belongs_to :wallet
  belongs_to :user

  def proces(params, user)
    Invite.transaction do
      update(params)
      wallet.users << user if params[:is_confirmed] == 'true'
    end
  end
end
