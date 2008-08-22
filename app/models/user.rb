class User < ActiveRecord::Base
  has_many :posts

  def admin?
    true
  end

  def self.current_user=(user)
    @@current_user = user 
  end
 
  def self.current_user
    @@current_user if defined? @@current_user
  end
  
  
end
