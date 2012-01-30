class Task < ActiveRecord::Base

  has_many :queries
  
  
  def new_tweets
    
    count = 0
    
    self.queries.each do |query|
      
      count += query.tweet_count
      
    end
    
    
    count
    
  end
     

end
