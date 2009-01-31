class PostsController < ResourceController::Base
  alias r_c_generated_object object

  new_action.wants.html do
    render_for_admin :html => @posts
  end

  index.wants.atom

  index.wants.html do
    @sticky = Post.sticky

    for_user_by_type do |type|
      case type
        when :anonymous
        when :user
          render :html => @posts
        when :admin
          if request.request_uri.downcase =~ /home/
            render :html => @posts
          else
            render :template => 'admin/posts/index', :html => @posts, :layout => "admin"
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
      my_object = Post.find_by_permalink params[:id]
    elsif params[:action] != 'create'
      my_object = Post.new
    else
      my_object = r_c_generated_object
    end
    my_object
  end

  def load_collection
    if params[:tag]
      @posts = Post.find_tagged_with params[:tag]
    elsif @current_user
      @posts = Post.posts_per_date
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

end
