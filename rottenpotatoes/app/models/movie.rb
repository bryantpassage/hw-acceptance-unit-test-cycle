class Movie < ActiveRecord::Base
    
    # class method of finding all movies with same director
    def self.find_same_director(movie_query)
        return self.where(director: movie_query.director)
    end
end
