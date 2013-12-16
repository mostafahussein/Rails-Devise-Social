#!/bin/env ruby
# encoding: utf-8
module CodeExtensions
	PARSE_FOR_PATH = ->(str) {
    str = FILTER_UMLAUTS.(str)
    str.gsub(/[^a-zA-Z 0-9]/, "").gsub(/\s/,'-')
  }

  FILTER_UMLAUTS = ->(str) {
    str = str.gsub("ü","ue")
    str = str.gsub("ö","oe")
    str = str.gsub("ä","ae")
    str = str.gsub("ß","ss")
  }

   TIME_AGO = ->(date) {
    time_ago = ''
    time_different = SECONDS_FRACTION_TO_TIME.(Time.now - (date.localtime.to_time))[0]
    if (time_different.to_i < 1)
      hours_different = SECONDS_FRACTION_TO_TIME.(Time.now - date.localtime.to_time)[1]
      if(hours_different >= 6)
        time_ago << "more than #{hours_different} hours ago"
      elsif (hours_different <= 6 && hours_different > 1)
        time_ago << "#{hours_different} hours ago"
      else
        minutes_defferent = SECONDS_FRACTION_TO_TIME.(Time.now - date.localtime.to_time)[2]
        if(minutes_defferent == 0)
          time_ago << "just now"
        elsif(minutes_defferent == 1)
          time_ago << "#{minutes_defferent} minute ago"
        else
          time_ago << "#{minutes_defferent} minutes ago"
        end
      end          
    else
      time_ago << (time_different == 1 ? "#{time_different} day ago." : "#{time_different} days ago")
    end     

    time_ago
  }

  SECONDS_FRACTION_TO_TIME = ->(time_difference) {
    days = hours = mins = 0
    mins = (time_difference / 60).to_i
    seconds = (time_difference % 60 ).to_i
    hours = (mins / 60).to_i
    mins = (mins % 60).to_i
    days = (hours / 24).to_i
    hours = (hours % 24).to_i

    [days,hours,mins,seconds]
  }

end