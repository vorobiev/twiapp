require 'open-uri'

class Runner
	
	
	def search
		
		
		tasks = Task.all
		
		for task in tasks do
		
		  for query in task.queries do
		
		
		    url = ''
		    counter = 0
		
		    if query.refresh_url == ''
  		    url = 'http://search.twitter.com/search.json?q=' + URI.escape( query.name ) + '&rpp=100&lang=ru&result_type=recent'
  		  else
    		  url = 'http://search.twitter.com/search.json' + query.refresh_url.to_s
    	  end
    	  
    	  
    	  puts url
    	  puts query.name
    	  
        refresh_url = ''
    
          while url != 'http://search.twitter.com/search.json' do
    
            puts 'opening url ' + url.to_s
    
      		  res = JSON.parse(open(url).read)
      		  
      		  if refresh_url == ''
        		  query.refresh_url = res['refresh_url']
        	  end
      
            url = 'http://search.twitter.com/search.json' + res['next_page'].to_s
            
            for result in res['results'] do
              
              t = Tweet.new
              
              t.user = result['from_user']
              t.text = result['text']
              t.date = result['created_at']
              t.tweet_id = result['id_str']
              t.query = query
              t.save
              
              
              counter += 1
              
            end
            
            
      
      	  end
      	  
      	  query.last_search = Time.now
      	#  query.tweet_count = counter
      	  query.save
      	
        end
        
        
        task.last_search = Time.now
        task.save
    	  
		
	  end	
		
		
	end	
	
	
end	