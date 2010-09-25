class ApplicationController < ActionController::Base
  protect_from_forgery
  
  @@model_names = {'sets'=>'card_sets'}
  
  before_filter :find_parents
  
  def find_parents
    fullpath = request.fullpath.split '/'
    fullpath.shift
    if fullpath.size>0 and fullpath[fullpath.size-1]=='edit'
      fullpath.pop
    end
    @parents = []
    logger.info("Looking at #{fullpath.inspect}")
    while fullpath.size > 2
      current = fullpath.slice!(0,2)
      current_type = current[0]
      logger.info(@@model_names.inspect)
      logger.info("#{current_type}->#{@@model_names[current_type]}")
      unless @@model_names[current_type].nil?
        current_type = @@model_names[current_type]
      end
      current_id = current[1]
      logger.info("looking for #{current_type}:#{current_id}")
      unless @parents[0].nil?
        logger.info("Parent Found")
        logger.info("Looking in #{@parents[0]}")
        logger.info("Calling ~.#{current_type.pluralize}.find(#{current_id})")
        new_parent = @parents[0].send(current_type.pluralize.to_sym).find(current_id)
      else
        logger.info("No Parents")
        logger.info("Looking in #{current_type}")
        collection = current_type.classify.constantize
        if collection.class == Array
          logger.info("Calling #{current_type.classify}.select{|i|i.id == #{current_id}}")
          new_parent = collection.select{|i|i.id == current_id}[0]
        else
          logger.info("Calling #{current_type.classify}.find(#{current_id})")
          new_parent = collection.find(current_id)
        end
      end
      
      if new_parent.nil?
        alert = "#{current_type.singularize}:#{current_id} not found"
        unless @parents[0].nil?
          alert += " in #{@parents[0].class.to_s.downcase}:#{@parents[0].id}"
        end
        logger.info("parent not found");
        redirect_to root_path, :alert=>alert
        return
      end
      logger.info("found: #{new_parent.inspect}")
      @parents.unshift new_parent
    end
  end
  
  def stacked_url obj
    url = @parents.reverse
    unless obj.nil
      return url_for url.push(obj)
    end
    return url_for url
  end
  
  def for_param main,param
    obj = params[main].delete(param)
    unless obj.nil?
      yield obj
    end
  end
end
