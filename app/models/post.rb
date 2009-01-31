class Post < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  has_permalink :title, :override_to_param => true
  acts_as_commentable :order => 'created_at desc', :conditions => "is_spam = 'f'"
  acts_as_taggable
  named_scope :sticky, :conditions => "sticky = 1", :order => 'start_time desc'
  named_scope :not_sticky, :conditions => {:sticky => false}
  named_scope :published#not respecting draft status yet, :conditions => {:is_published => true, :is_published => false, :is_published => nil}

  def self.posts_per_date
    published.to_set.classify { |post| post.created_at.to_date }
  end

end
