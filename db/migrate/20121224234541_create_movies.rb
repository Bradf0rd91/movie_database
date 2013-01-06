class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :year
      t.string :type
      t.string :loanee

      t.timestamps
    end
  end
end
