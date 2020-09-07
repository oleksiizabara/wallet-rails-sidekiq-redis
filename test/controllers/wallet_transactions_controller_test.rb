require 'test_helper'

class WalletTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @wallet_transaction = wallet_transactions(:one)
  end

  test "should get index" do
    get wallet_transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_wallet_transaction_url
    assert_response :success
  end

  test "should create wallet_transaction" do
    assert_difference('WalletTransaction.count') do
      post wallet_transactions_url, params: { wallet_transaction: {  } }
    end

    assert_redirected_to wallet_transaction_url(WalletTransaction.last)
  end

  test "should show wallet_transaction" do
    get wallet_transaction_url(@wallet_transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_wallet_transaction_url(@wallet_transaction)
    assert_response :success
  end

  test "should update wallet_transaction" do
    patch wallet_transaction_url(@wallet_transaction), params: { wallet_transaction: {  } }
    assert_redirected_to wallet_transaction_url(@wallet_transaction)
  end

  test "should destroy wallet_transaction" do
    assert_difference('WalletTransaction.count', -1) do
      delete wallet_transaction_url(@wallet_transaction)
    end

    assert_redirected_to wallet_transactions_url
  end
end
