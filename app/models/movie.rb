class Movie < ActiveRecord::Base
def self.all_ratings
arr=[]
Movie.all.each do |m|
       until arr.include?(m.rating) do
         arr+=[m.rating]
       end
    end
return arr
end
end
