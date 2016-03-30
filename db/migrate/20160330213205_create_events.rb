class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true
      t.text :description
      t.text :description_html
      t.string :title
      t.string :location
      t.attachment :background_image
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :private, default: false, null: false

      t.timestamps null: false
    end
  end
end
