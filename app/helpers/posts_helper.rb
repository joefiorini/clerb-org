module PostsHelper

  def tags_for(post)
    tags = post.tag_list.map do |t|
      link_to t, tag_url(t)
    end
    tags.join " &ndash; "
  end

  def locations_for_select_list
    Location.all.map { |location| [location.name, location.id] }
  end
end
