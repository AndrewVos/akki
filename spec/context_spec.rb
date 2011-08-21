require 'akki/context'

module Akki
  describe Context do
    it "stores arbitrary values" do
      context = Context.new
      context.value = "hello"
      context.value.should == "hello"
    end
  end
end
