require 'remit/common'

module Remit
  module Pay
    class Request < Remit::Request
      action :Pay
      parameter :caller_description
      parameter :caller_reference, :required => true
      parameter :charge_fee_to, :required => false
      parameter :descriptor_policy, :type => Remit::RequestTypes::DescriptorPolicy
      parameter :marketplace_fixed_fee, :type => Remit::RequestTypes::Amount
      parameter :marketplace_variable_fee
      parameter :recipient_token_id, :required => true
      parameter :sender_description
      parameter :sender_token_id, :required => true
      parameter :transaction_amount, :type => Remit::RequestTypes::Amount, :required => true
    end

    class PayResponse < Remit::Response
      parser :rexml
      parameter :pay_result, :type => TransactionResponse
    end

    def pay(request = Request.new)
      call(request, PayResponse)
    end
  end
end
