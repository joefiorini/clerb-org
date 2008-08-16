class Post < ActiveRecord::Base
	belongs_to :author, :class_name => 'User'
	before_save :generate_permalink
  acts_as_commentable :order => 'created_at desc', :conditions => "is_spam = 'f'"
	acts_as_taggable
	named_scope :sticky, :conditions => ["sticky = 't' and ((type = 'Event' and start_time > ?) or type is null)", DateTime.now], :order => 'start_time desc'
  named_scope :not_sticky, :conditions => {:sticky => false}
  named_scope :published#not respecting draft status yet, :conditions => {:is_published => true, :is_published => false, :is_published => nil}
  
  def self.posts_per_date
    published.to_set.classify { |post| post.created_at.to_date }
  end
  
	def generate_permalink
		#raise self.attributes.to_s
		if self.permalink.nil?
			self.permalink = self.title.sanitize_for_url
			self.save
		end
	end

end
