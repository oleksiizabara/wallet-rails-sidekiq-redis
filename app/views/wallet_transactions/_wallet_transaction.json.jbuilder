json.extract! wallet_transaction, :id, :created_at, :updated_at
json.url wallet_transaction_url(wallet_transaction, format: :json)
