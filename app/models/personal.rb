# frozen_string_literal: true

class Personal < Wallet
  TransferResult = Struct.new(:status, :error_message)
  def new_wallet(params, owner)
    assign_attributes(is_private: true,
                      admin_id: owner.id,
                      identity: params[:wallet_identity],
                      currency_id: params[:currency_id], 
                      description: params[:description])
    users << owner if save!
  end
end
