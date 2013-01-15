# == Schema Information
#
# Table name: movies
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  year       :string(255)
#  rec_form   :string(255)
#  loanee     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Movie < ActiveRecord::Base
  attr_accessible :loanee, :title, :rec_form, :year, :active
  belongs_to :user

  YEAR_FORMAT = /[0-9][0-9][0-9][0-9]|Unknown/

  validates_presence_of :user_id
  validates :title, uniqueness: { scope: :rec_form }
  validates :year, format: { with: YEAR_FORMAT}

  after_validation :log_errors, :if => Proc.new {|m| m.errors}

  def self.to_csv action
    columns = %w{title year rec_form}
    case action
    when "checked","all"
      headers = %w{title year format loanee owner}
    when "requested"
      headers = %w{title year format owner}
    when "mine"
      headers = %w{title year format loanee}
    end
    CSV.generate do |csv|
      csv << headers
      all.each do |movie|
        if headers.include?("loanee")
          if headers.include?("owner")
            csv << [movie.title, movie.year, movie.rec_form, movie.loanee, User.find(movie.user_id).name]
          else
            csv << [movie.title, movie.year, movie.rec_form, movie.loanee]
          end
        elsif headers.include?("owner")
          csv << [movie.title, movie.year, movie.rec_form, User.find(movie.user_id).name]
        else
          csv << movie.attributes.values_at(*columns)
        end
      end
    end
  end

  def log_errors
    Rails.logger.info self.errors.full_messages.join("\n")
  end

  define_index do
    indexes title, sortable: true
    indexes rec_form
    indexes user.name, as: :owner
    indexes loanee, sortable: true
    indexes active
  end
end
