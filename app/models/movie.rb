class Movie < ActiveRecord::Base
  ## create values for movie ratings
  class << self
    # retrieve unique ratings from 'rating' feature
    def ratings
      Movie.uniq.pluck(:rating).sort
    end
    # get list of movies based on rating, and ordered ascending
    def movie_list rating, ordering
      Movie.where(rating: rating).order(ordering)
    end
  end
end
