module ApplicationHelper
  
  def new_user_session_path
    url_for({:action=>"new", :controller=>"devise/sessions"})
  end
  
  def actionize path
    logger.info("actionizing: #{path}")
    result = String.new(path)
    last_slash = result.rindex '/'
    if last_slash.nil?
      last_slash = -1
    end
    result.insert(last_slash+1,'a_')
    logger.info("result: #{result}")
    logger.info("original: #{path}")
    return result 
  end
end
