#require File.dirname(__FILE__) + '/spec_helper'
#require File.dirname(__FILE__) + '/model/product'
#require File.dirname(__FILE__) + '/model/consultant'
require File.dirname(__FILE__) + '/../../../../spec/spec_helper'

describe 'When executing code for an admin' do
  
  class AuthDummy
    include HelperAuth
  end

  describe 'and user is nil' do
	  it "should return false" do

      AuthDummy dummy = AuthDummy.new

      result = dummy.for_admin_only {}
      
      result.should be_false
	    
	  end
  end
  
end


