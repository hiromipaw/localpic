class AddImageToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :image_id, :string
  end
end
