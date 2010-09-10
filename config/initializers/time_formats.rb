class Time
  def to_html5_datetime
    strftime("%Y-%m-%dT%H:%M:%S%z")
  end
  
  def to_readable_format
    localtime.strftime("at %l:%M on %B %e, %Y")
  end
end