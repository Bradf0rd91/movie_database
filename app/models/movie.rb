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
  attr_accessible :loanee, :title, :rec_form, :year
  belongs_to :user

  YEAR_FORMAT = /[0-9][0-9][0-9][0-9]|Unknown/

  validates_presence_of :user_id
  validates :title, uniqueness: { scope: :rec_form }
  validates :year, format: { with: YEAR_FORMAT}

  after_validation :log_errors, :if => Proc.new {|m| m.errors}

  def log_errors
    Rails.logger.info self.errors.full_messages.join("\n")
  end

  define_index do
    indexes title, sortable: true
    indexes rec_form
    indexes user.name, as: :owner
    indexes loanee, sortable: true
  end
end
