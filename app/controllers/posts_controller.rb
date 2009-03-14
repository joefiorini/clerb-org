class PostsController < ResourceController::Base

  new_action.wants.html do
    render_for_admin :layout => "admin"
  end

  edit.wants.html { render_for_admin :layout => "admin" }

  index.wants.atom

  index.wants.html do
    @sticky = Post.sticky unless params[:meetings]

    for_user_by_type do |type|
      case type
        when :anonymous
        when :user
          render :html => @posts
        when :admin
          if request.request_uri.downcase =~ /home/
            render :html => @posts
          else
            render :template => 'admin/posts/index', :layout => "admin"
          end
      end
    end
  end

  create.before { @post.author = @current_user }

  show.wants.html do
    if params[:day] and params[:month] and params[:year]
      ex = "#{params[:month]}/#{params[:day]}/#{params[:year]}"
    elsif params[:year]
      ex = "Year: #{params[:year]}"
    end
  end

  show.wants.xml { render :xml => @post }
  new_action.wants.xml { render :xml => @post }
  index.wants.xml { render :xml => @posts }
  create.wants.xml { render :xml => @posts }
  update.wants.xml { render :xml => @post }
  destroy.wants.xml { head :ok }

protected

  def object
    if params[:id]
      @object ||= Post.find_by_permalink params[:id]
    elsif params[:action] != 'create'
      @object ||= Post.new
    elsif params[:meetings]
      @object = Post.old
    else
      @object ||= Post.all
    end
  end

  def collection
    if params[:tag]
      @posts = Post.find_tagged_with params[:tag]
    elsif @current_user
      @posts = Post.posts_per_date
    elsif params[:meetings]
      @posts = Post.old :limit => 12, :order => 'start_time desc'
    else
      for_user_by_type do |type|
        if type == :admin
          @posts = Post.posts_per_date
        else
          @posts = Post.not_sticky.all  :limit => 10, :order => "created_at desc"
        end
      end
    end
  end

  def layout_for_user
    for_user_by_type do |user_type|
      case user_type
        when :admin
          "admin"
        else
          "application"
      end
    end
  end

end
