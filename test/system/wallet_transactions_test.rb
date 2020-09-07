require "application_system_test_case"

class WalletTransactionsTest < ApplicationSystemTestCase
  setup do
    @wallet_transaction = wallet_transactions(:one)
  end

  test "visiting the index" do
    visit wallet_transactions_url
    assert_selector "h1", text: "Wallet Transactions"
  end

  test "creating a Wallet transaction" do
    visit wallet_transactions_url
    click_on "New Wallet Transaction"

    click_on "Create Wallet transaction"

    assert_text "Wallet transaction was successfully created"
    click_on "Back"
  end

  test "updating a Wallet transaction" do
    visit wallet_transactions_url
    click_on "Edit", match: :first

    click_on "Update Wallet transaction"

    assert_text "Wallet transaction was successfully updated"
    click_on "Back"
  end

  test "destroying a Wallet transaction" do
    visit wallet_transactions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Wallet transaction was successfully destroyed"
  end
end
