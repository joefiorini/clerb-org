ActionController::Routing::Routes.draw do |map|
  map.resources :locations
  map.p_location 'locations/:permalink', :controller => 'locations', :action => 'view'
  map.resources :events

  map.root :controller => 'posts'
  map.meetings '/meetings', :controller => 'Posts', :action => 'index', :meetings => true
  map.about '/about', :controller => 'TemporaryContent', :action => 'coming_soon'
  map.contact '/contact', :controller => 'TemporaryContent', :action => 'coming_soon'
  map.groups_resources '/resources', :controller => 'TemporaryContent', :action => 'coming_soon'
  map.posts_for_date ':year/:month/:day', :controller => 'posts', :action => 'show', :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/
  map.posts_for_year ':year', :controller => 'posts', :action => 'show', :year => /\d{4}/
  map.home 'home', :controller => 'posts'
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.feed  'feed', :controller => 'posts', :action => 'index', :format => 'atom'
  map.comments_for_post 'posts/show/:id', :controller => 'posts', :action => 'show', :anchor => 'comments'
  map.tag 'posts/tags/:tag', :controller => 'posts', :action => 'index'

  map.resources :posts, :has_many => :comments

  map.open_id_complete 'session', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.resource :session

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
