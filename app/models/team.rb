# frozen_string_literal: true

class Team < Wallet
  def new_wallet(params, owner)
    assign_attributes(is_private: params[:is_private],
                      identity: params[:wallet_identity],
                      currency_id: params[:currency_id],
                      admin_id: owner.id,
                      description: params[:description])
    users << owner if save!
  end
end
