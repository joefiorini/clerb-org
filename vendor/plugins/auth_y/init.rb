# Include hook code here
require File.dirname(__FILE__) + '/lib/authy'

class ActionController::Base
  include AuthY
end

class ApplicationHelper
  include AuthY
end
