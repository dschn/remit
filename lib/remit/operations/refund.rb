require 'remit/common'

module Remit
  module Refund
    class Request < Remit::Request
      action :Refund
      parameter :caller_description
      parameter :caller_reference, :required => true
      parameter :refund_amount, :type => Remit::RequestTypes::Amount
      parameter :transaction_id, :required => true

      # The RefundAmount parameter has multiple components.  It is specified on the query string like
      # so: RefundAmount.Amount=XXX&RefundAmount.CurrencyCode=YYY
      def convert_complex_key(key, parameter)
        "#{convert_key(key).to_s}.#{convert_key(parameter).to_s}"
      end
    end

    class RefundResponse < Remit::Response
      parser :rexml
      parameter :refund_result, :type => TransactionResponse
    end

    def refund(request = Request.new)
      call(request, RefundResponse)
    end
  end
end
