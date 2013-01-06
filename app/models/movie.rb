class Movie < ActiveRecord::Base
  attr_accessible :loanee, :title, :rec_form, :year

  YEAR_FORMAT = /[0-9][0-9][0-9][0-9]|Unknown/

  validates :title, uniqueness: { scope: :rec_form }
  validates :year, format: { with: YEAR_FORMAT}

  after_validation :log_errors, :if => Proc.new {|m| m.errors}

  def log_errors
    Rails.logger.info self.errors.full_messages.join("\n")
  end
end
