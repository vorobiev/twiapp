class Tweet < ActiveRecord::Base
  belongs_to :query
  
  
  def parsed_text
    URI::extract(self.text).uniq.each{|uri| self.text.gsub!(uri, "<a href='#{uri}'>#{uri}</a>")}
    return text
  end
  
end
