module AuthY
  def for_admin_only(&block)
    for_user_by_type do |type|
      if User.current_user.admin?
        yield
        return true
      end
    end

    false
  end

  def for_user_by_type
    if not User.current_user
      yield :anonymous
    elsif User.current_user.admin? 
      yield :admin 
    elsif User.current_user
      yield :user
    end
  end

  def render_for_admin *args
 
    admin = for_admin_only do
      render *args
    end
    
    render :nothing => true, :status => 401 unless admin
  end
  
end
