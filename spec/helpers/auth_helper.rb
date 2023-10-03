require './app/services/token_helper'
require './app/services/account_finder'

module AuthHelper
  include TokenHelper
  include AccountFinder

  def access_token(payload)
    account = find_account(payload)
    payload_to_encode = { email: account.email, role: account.role } 
    access_token = encode_access_token(payload_to_encode)
    account.update(access_token: access_token)
    return "Bearer #{access_token}"
  end
end