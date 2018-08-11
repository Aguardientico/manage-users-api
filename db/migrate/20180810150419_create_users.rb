class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :job_title
      t.boolean :is_admin, null: false, default: false
      t.string :hashed_id, null: false

      t.timestamps

      t.index "email", unique: true
      t.index "hashed_id", unique: true
    end
  end
end
