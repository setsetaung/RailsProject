class CreateTDirMsgStrs < ActiveRecord::Migration[5.2]
  def change
    create_table :t_dir_msg_strs do |t|
      t.string :t_dir_msg_id
      t.string :integer
      t.integer :dir_str_user_id

      t.timestamps
    end
  end
end
