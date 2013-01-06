class ChangeMoviesColumnNames < ActiveRecord::Migration
  def change
    rename_column :movies, :type, :rec_form
  end
end
