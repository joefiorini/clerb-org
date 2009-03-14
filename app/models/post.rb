class Post < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  belongs_to :location
  has_permalink :title, :override_to_param => true
  acts_as_commentable :order => 'created_at desc', :conditions => "is_spam = 'f'"
  acts_as_taggable
  named_scope :sticky, :conditions => {:sticky => true}, :order => 'start_time desc'
  named_scope :not_sticky, :conditions => {:sticky => false}
  named_scope :old, :conditions => ['start_time < ?', DateTime.now]
  named_scope :published#not respecting draft status yet, :conditions => {:is_published => true, :is_published => false, :is_published => nil}
  validates_presence_of :start_time, :if => Proc.new { |post| post.post_type == "event" }
  validates_presence_of :location, :if => Proc.new { |post| post.post_type == "event" }

  def self.posts_per_date
    published.to_set.classify { |post| post.created_at.to_date }
  end

end
