class Movie < ActiveRecord::Base

  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    
    if ratings_list.empty?
      return Movie.all
    
    else
      
      tuple_s = "("
      ratings_list.each do |n| 
          tuple_s += "'#{n.downcase}', " + "'#{n.upcase}', "
      end
      tuple_s = tuple_s[0..-3]
      tuple_s += ")"
      
      
      
        
      return Movie.where(["rating IN #{tuple_s}"])
    
    end
  
  end
  

end
