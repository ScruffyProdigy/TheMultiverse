module MongoidArrayHelper
  def read_array the_attr
    current = read_attribute the_attr
    if current.nil?
      current = []
    end
    return current
  end

  def write_array the_attr,the_array
    write_attribute the_attr,the_array
  end

  def add_to_array the_attr,the_obj
    current = read_array the_attr
    current << the_obj
    write_array the_attr,current
  end

  def remove_from_array the_attr,the_obj
    current = read_array the_attr
    result = current.delete the_obj
    write_array the_attr,current
    return result
  end

  def map_array the_attr,mapper
    ids = read_array the_attr
    ids.map {|id| mapper.find(id)}
  end
end