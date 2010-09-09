module ApplicationHelper
  
  def new_user_session_path
    url_for({:action=>"new", :controller=>"devise/sessions"})
  end
end
