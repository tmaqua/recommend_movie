class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.string :movie_url
      t.string :image_url

      t.timestamps null: false
    end
  end
end
