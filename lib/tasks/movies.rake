require File.dirname(__FILE__)+'/../../config/environment.rb'
require File.dirname(__FILE__)+'/../movies.rb'
require 'csv'

namespace :movies do
  task :import => :environment do
    log = Logger.new("#{Rails.root}/log/#{Rails.env}.log")
    file = '/Users/brad/Desktop/movies.csv'
    CSV.foreach(file) do |row|
      title = row[0]
      year = row[1]
      type = row[2]
      user = User.first
      unless Mov.valid_year? year
        title = title << ", #{year.strip}"
        year = type
        type = row[3]
        unless Mov.valid_year?(year) and Mov.valid_type?(type)
          raise %Q{
            Is this better?\n
            Title: #{title}\n
            Year: #{type}\n
            Type: #{row[3]}
          }
        end
      end
      log.info "Generating record for #{title}"
      user.movies.create(title: title, year: year, rec_form: type)
      if Movie.find_by_title(title).blank?
        log.error "Failed importing #{title}"
      else
        log.info "Success!"
      end
    end
  end
  task :reset => :environment do
    movies = Movie.all
    movies.each do |t|
      Movie.destroy(t)
    end
  end
end
