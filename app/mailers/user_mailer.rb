class UserMailer < ActionMailer::Base
  default from: "brad.rice91@gmail.com"

  def alert_users(owner, user, movie)
    @owner = owner
    @user = user
    @movie = movie
    mail(to: user.email, subject: "New Movie")
  end

  def movie_request(owner, user, movie)
    @owner = owner
    @user = user
    @movie = movie
    mail(to: user.email, subject: "A movie has been requested")
  end
end
