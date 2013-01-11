class AddActiveColumnToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :active, :bool, :default => true, :null => false
  end
end
