require File.dirname(__FILE__) + '/units_helper'

describe "the Pay API" do
  describe "a successful response" do
    it_should_behave_like 'a successful response'

    before do
      doc = <<-XML
        <PayResponse xmlns="http://fps.amazonaws.com/doc/2008-09-17/">
           <PayResult>
              <TransactionId>14GK6BGKA7U6OU6SUTNLBI5SBBV9PGDJ6UL</TransactionId>
              <TransactionStatus>Pending</TransactionStatus>
           </PayResult>
           <ResponseMetadata>
              <RequestId>c21e7735-9c08-4cd8-99bf-535a848c79b4:0</RequestId>
           </ResponseMetadata>
        </PayResponse>        
      XML

      @response = Remit::Pay::PayResponse.new(doc)
    end

    it "has a transaction response" do
      @response.pay_result.should_not be_nil
    end

    it "has a transaction id" do
      @response.pay_result.transaction_id == '14GK6BGKA7U6OU6SUTNLBI5SBBV9PGDJ6UL'
    end

    it "has a transaction status" do
      @response.pay_result.transaction_status.should == 'Pending'
    end

    it "has status shortcuts" do
      @response.pay_result.should be_pending
    end
  end

  describe "for a failed request" do
    before do
      doc = <<-XML
        <?xml version=\"1.0\"?>
        <Response>
          <Errors>
            <Error>
              <Code>InvalidParams</Code>
              <Message>callerReference can not be empty </Message>
            </Error>
          </Errors>
          <RequestID>7ca7472b-1ce1-408b-be8f-e7e838090b56</RequestID>
        </Response>
      XML

      @response = Remit::Pay::PayResponse.new(doc)
      @error = @response.errors.first
    end

    it_should_behave_like 'a failed response'

    describe "with an invalid params error" do
      it "should be a service error" do
        @error.should be_kind_of(Remit::Error)
      end

      #it "should have an error type of 'Business'" do
      #  @error.error_type.should == 'Business'
      #end

      it "should have an error code of 'InvalidParams'" do
        @error.code.should == 'InvalidParams'
      end

      #it "should not be retriable" do
      #  @error.is_retriable.should == 'false'
      #end
      it "should have a request id" do
        @response.request_id.should == '7ca7472b-1ce1-408b-be8f-e7e838090b56' 
      end

      it "should have message" do
        @error.message.should == 'callerReference can not be empty '
      end
    end
  end

  describe "for a failed response" do
    before do
      doc = <<-XML
        <?xml version=\"1.0\"?>
        <Response>
          <Errors>
            <Error>
              <Code>IncompatibleTokens</Code>
              <Message>The transaction could not be completed because the tokens have incompatible payment instructions: \nTransaction amount not equal to accepted value</Message>
            </Error>
          </Errors>
          <RequestID>2f6ab78b-60a8-4c68-a067-93e2b6d49377</RequestID>
        </Response>
      XML

      @response = Remit::Pay::PayResponse.new(doc)
      @error = @response.errors.first
    end

    it_should_behave_like 'a failed response'

    describe "with a token usage error" do
      it "should be a service error" do
        @error.should be_kind_of(Remit::Error)
      end

      #it "should have an error type of 'Business'" do
      #  @error.error_type.should == 'Business'
      #end

      it "should have an error code of 'IncompatibleTokens'" do
        @error.code.should == 'IncompatibleTokens'
      end

      #it "should not be retriable" do
      #  @error.is_retriable.should == 'false'
      #end

      it "should have message" do
        @error.message.should == "The transaction could not be completed because the tokens have incompatible payment instructions: \nTransaction amount not equal to accepted value"
      end
    end
  end
end
