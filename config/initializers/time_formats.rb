class Time
  def to_html5_datetime(time_zone = Time.zone_offset(Time.now().zone))
    localtime(time_zone).strftime("%Y-%m-%dT%H:%M:%S%z")
  end
  
  def to_readable_format(time_zone = Time.zone_offset(Time.now().zone))
    localtime(time_zone).strftime("at %l:%M on %B %e, %Y")
  end
end